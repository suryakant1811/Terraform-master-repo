variable "name" {
  description = "Name used for the DB instance and supporting resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the database security group."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Provide at least two private subnet IDs in different Availability Zones."
  }
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database."
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "Database engine."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Optional database engine version."
  type        = string
  default     = null
}

variable "port" {
  description = "Database listener port."
  type        = number
  default     = 3306
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB. Zero disables storage autoscaling."
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "RDS storage type."
  type        = string
  default     = "gp3"
}

variable "database_name" {
  description = "Name of the initial database."
  type        = string
}

variable "username" {
  description = "Master database username."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master database password. Supply it through a secret environment variable or secret manager."
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to deploy a Multi-AZ database."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to protect the DB instance from deletion."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip a final snapshot when deleting the instance."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to every resource."
  type        = map(string)
  default     = {}
}
