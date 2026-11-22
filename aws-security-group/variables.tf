variable "name" {
  description = "Name prefix used for the security group and its Name tag."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the security group."
  type        = string
}

variable "description" {
  description = "Security group description."
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "Inbound rules for the security group."
  type = list(object({
    description               = optional(string, "Managed by Terraform")
    from_port                 = number
    to_port                   = number
    protocol                  = string
    cidr_blocks               = optional(list(string), [])
    ipv6_cidr_blocks          = optional(list(string), [])
    prefix_list_ids           = optional(list(string), [])
    source_security_group_id  = optional(string)
    source_security_group_ids = optional(list(string), [])
    self                      = optional(bool, false)
  }))
  default = []
}

variable "egress_rules" {
  description = "Outbound rules. Ignored when allow_all_egress is true."
  type = list(object({
    description               = optional(string, "Managed by Terraform")
    from_port                 = number
    to_port                   = number
    protocol                  = string
    cidr_blocks               = optional(list(string), [])
    ipv6_cidr_blocks          = optional(list(string), [])
    prefix_list_ids           = optional(list(string), [])
    source_security_group_id  = optional(string)
    source_security_group_ids = optional(list(string), [])
    self                      = optional(bool, false)
  }))
  default = []
}

variable "allow_all_egress" {
  description = "When true, adds a single egress rule allowing all traffic (IPv4 and IPv6)."
  type        = bool
  default     = true
}

variable "revoke_rules_on_delete" {
  description = "Whether to revoke attached rules before deleting the security group."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the security group."
  type        = map(string)
  default     = {}
}