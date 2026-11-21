variable "name" {
  description = "Name of the EC2 instance and its optional security group."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used to launch the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet in which to launch the EC2 instance."
  type        = string
}

variable "vpc_id" {
  description = "VPC used when create_security_group is true."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IPv4 address with the instance."
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Optional EC2 key pair name."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Optional IAM instance profile name."
  type        = string
  default     = null
}

variable "user_data" {
  description = "Optional cloud-init or shell user data. Do not put long-lived secrets here."
  type        = string
  default     = null
  sensitive   = true
}

variable "create_security_group" {
  description = "Whether this module should create a security group."
  type        = bool
  default     = true
}

variable "additional_security_group_ids" {
  description = "Existing security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "Inbound rules for the module-created security group."
  type = list(object({
    description      = optional(string, "Managed by Terraform")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "allow_all_egress" {
  description = "Whether the module-created security group permits all outbound traffic."
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root EBS volume."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ARN used to encrypt the root EBS volume."
  type        = string
  default     = null
}

variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed CloudWatch monitoring."
  type        = bool
  default     = false
}

variable "source_dest_check" {
  description = "Whether to enable source/destination checking."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to every resource."
  type        = map(string)
  default     = {}
}
