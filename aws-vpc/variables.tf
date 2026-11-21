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
    error_message = "Provide at least one public subnet."
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
    error_message = "Provide at least one private subnet."
  }
}

variable "database_subnets" {
  description = "Database subnets keyed by a stable name."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  validation {
    condition     = length(var.database_subnets) > 0
    error_message = "Provide at least one database subnet."
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
