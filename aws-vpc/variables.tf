variable "name" {
  description = "Name prefix used for VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability Zones used by the public and private subnets."
  type        = list(string)

  validation {
    condition     = length(var.azs) > 0
    error_message = "Provide at least one Availability Zone."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks. Each index is matched to the same index in azs."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "Provide at least one public subnet CIDR block."
  }
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks. Each index is matched to the same index in azs."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "Provide at least one private subnet CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create one NAT gateway for private subnet internet access."
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_index" {
  description = "Index of the public subnet in which to place the NAT gateway."
  type        = number
  default     = 0

  validation {
    condition     = var.nat_gateway_subnet_index >= 0 && var.nat_gateway_subnet_index < length(var.public_subnets)
    error_message = "nat_gateway_subnet_index must identify an item in public_subnets."
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
