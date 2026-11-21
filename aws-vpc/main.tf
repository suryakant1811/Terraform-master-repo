locals {
  public_subnets = {
    for index, cidr_block in var.public_subnets : format("public-%02d", index + 1) => {
      cidr_block        = cidr_block
      availability_zone = var.azs[index % length(var.azs)]
    }
  }

  private_subnets = {
    for index, cidr_block in var.private_subnets : format("private-%02d", index + 1) => {
      cidr_block        = cidr_block
      availability_zone = var.azs[index % length(var.azs)]
    }
  }

  database_subnets = {
    for index, cidr_block in var.database_subnets : format("database-%02d", index + 1) => {
      cidr_block        = cidr_block
      availability_zone = var.azs[index % length(var.azs)]
    }
  }

  default_nat_gateway_subnet_key = sort(keys(local.public_subnets))[0]
  nat_gateway_subnet_key = var.nat_gateway_subnet_key != null && contains(keys(local.public_subnets), var.nat_gateway_subnet_key) ? (
    var.nat_gateway_subnet_key
  ) : local.default_nat_gateway_subnet_key
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    precondition {
      condition     = length(var.public_subnets) == length(var.azs)
      error_message = "public_subnets must contain one CIDR block for each item in azs."
    }

    precondition {
      condition     = length(var.private_subnets) == length(var.azs)
      error_message = "private_subnets must contain one CIDR block for each item in azs."
    }

    precondition {
      condition     = length(var.database_subnets) == length(var.azs)
      error_message = "database_subnets must contain one CIDR block for each item in azs."
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
    Tier = "private"
  })
}

resource "aws_subnet" "database" {
  for_each = local.database_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
    Tier = "database"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat"
  })

  depends_on = [aws_internet_gateway.this]

  lifecycle {
    precondition {
      condition     = var.nat_gateway_subnet_key == null ? true : contains(keys(local.public_subnets), var.nat_gateway_subnet_key)
      error_message = "nat_gateway_subnet_key must be a key from public_subnets."
    }
  }
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[local.nat_gateway_subnet_key].id

  tags = merge(var.tags, {
    Name = "${var.name}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private"
  })
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_database_nat_route && var.enable_nat_gateway ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-database"
  })

  lifecycle {
    precondition {
      condition     = !var.enable_database_nat_route || var.enable_nat_gateway
      error_message = "enable_nat_gateway must be true when enable_database_nat_route is true."
    }
  }
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}
