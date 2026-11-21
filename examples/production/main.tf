locals {
  name = "paywave-${var.environment}"
}

module "vpc" {
  source = "../../aws-vpc"

  name            = "${local.name}-vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.common_tags
}

module "ecr" {
  source = "../../aws-ecr"

  repository_names = var.ecr_repository_names
  tags             = var.common_tags
}

module "rds" {
  source = "../../aws-rds"

  name                = "${local.name}-mysql"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  allowed_cidr_blocks = module.vpc.private_subnet_cidrs

  engine         = "mysql"
  instance_class = "db.t3.micro"
  database_name  = var.database_name
  username       = var.database_username
  password       = var.database_password

  allocated_storage       = 20
  backup_retention_period = 7
  deletion_protection     = true
  skip_final_snapshot     = false
  tags                    = var.common_tags
}

module "eks" {
  source = "../../aws-eks"

  cluster_name = "${local.name}-eks"
  subnet_ids   = module.vpc.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = length(var.eks_public_access_cidrs) > 0
  public_access_cidrs     = var.eks_public_access_cidrs

  node_group_name     = "workers"
  node_instance_types = ["t3.small"]
  desired_size        = 2
  min_size            = 1
  max_size            = 2
  tags                = var.common_tags
}
