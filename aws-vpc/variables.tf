variable "name" {
  description = "Name prefix used for VPC resources."
  type        = string
  default     = "vpc"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability Zones assigned to subnet CIDRs by matching list index."
  type        = list(string)

  validation {
    condition     = length(var.azs) > 0
    error_message = "Provide at least one Availability Zone."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks corresponding by index to azs."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "Provide at least one public subnet CIDR block."
  }
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks corresponding by index to azs."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "Provide at least one private subnet CIDR block."
  }
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks corresponding by index to azs."
  type        = list(string)

  validation {
    condition     = length(var.database_subnets) > 0
    error_message = "Provide at least one database subnet CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create one NAT gateway for private subnet internet access."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_key" {
  description = "Generated public subnet key (for example, public-01) in which to place the NAT gateway. Null uses public-01."
  type        = string
  default     = null
}

variable "enable_database_nat_route" {
  description = "Whether the database route table receives a default route through the NAT gateway."
  type        = bool
  default     = false
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
