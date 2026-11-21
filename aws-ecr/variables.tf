variable "repository_names" {
  description = "Names of the ECR repositories to create."
  type        = set(string)

  validation {
    condition     = length(var.repository_names) > 0
    error_message = "Provide at least one ECR repository name."
  }
}

variable "image_tag_mutability" {
  description = "Tag mutability setting: MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Whether to scan container images when pushed."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Whether Terraform may delete repositories that still contain images."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to every repository."
  type        = map(string)
  default     = {}
}
