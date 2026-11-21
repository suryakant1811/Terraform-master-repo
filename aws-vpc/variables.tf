variable "name" {
  description = "Name prefix used for VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnets keyed by a stable name."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "At least one public subnet is required."
  }
}

variable "private_subnets" {
  description = "Private subnets keyed by a stable name."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "At least one private subnet is required."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create one NAT gateway for private subnet internet access."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Public subnet key in which to place the NAT gateway. Null uses the first sorted key."
  type        = string
  default     = null

  validation {
    condition     = var.nat_gateway_subnet_key == null ? true : contains(keys(var.public_subnets), var.nat_gateway_subnet_key)
    error_message = "nat_gateway_subnet_key must be a key from public_subnets."
  }
}

variable "enable_dns_support" {
  description = "Whether the VPC supports DNS resolution."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether instances in the VPC receive DNS hostnames."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to every resource."
  type        = map(string)
  default     = {}
}
