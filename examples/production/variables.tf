variable "aws_region" {
  description = "AWS region in which to deploy the infrastructure."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.104.0.0/16"
}

variable "azs" {
  description = "Availability Zones used by the VPC subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks corresponding by index to azs."
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks corresponding by index to azs."
  type        = list(string)
}

variable "ecr_repository_names" {
  description = "ECR repositories to create."
  type        = set(string)
}

variable "database_name" {
  description = "Name of the initial MySQL database."
  type        = string
  default     = "prodmysqldb"
}

variable "database_username" {
  description = "MySQL master username."
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "MySQL master password. Set with TF_VAR_database_password; do not commit it."
  type        = string
  sensitive   = true
}

variable "eks_public_access_cidrs" {
  description = "CIDRs permitted to access the public EKS API endpoint."
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Tags added to all AWS resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "paywave"
  }
}
