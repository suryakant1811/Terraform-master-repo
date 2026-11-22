locals {
  description = coalesce(var.description, "Security group for ${var.name}")
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = local.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      prefix_list_ids = length(ingress.value.prefix_list_ids) > 0 ? ingress.value.prefix_list_ids : null
      security_groups = try(
        length(ingress.value.source_security_group_ids) > 0 ? ingress.value.source_security_group_ids : null,
        null
      )
      source_security_group_id = try(ingress.value.source_security_group_id, null)
      self                     = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.allow_all_egress ? [1] : var.egress_rules

    content {
      description = var.allow_all_egress ? "Allow all outbound traffic" : egress.value.description

      from_port = var.allow_all_egress ? 0 : egress.value.from_port
      to_port   = var.allow_all_egress ? 0 : egress.value.to_port
      protocol  = var.allow_all_egress ? "-1" : egress.value.protocol

      cidr_blocks      = var.allow_all_egress ? ["0.0.0.0/0"] : (length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null)
      ipv6_cidr_blocks = var.allow_all_egress ? ["::/0"] : (length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null)
      prefix_list_ids  = var.allow_all_egress ? null : (length(egress.value.prefix_list_ids) > 0 ? egress.value.prefix_list_ids : null)

      security_groups          = var.allow_all_egress ? null : egress.value.source_security_group_ids
      source_security_group_id = var.allow_all_egress ? null : egress.value.source_security_group_id
      self                     = var.allow_all_egress ? false : egress.value.self
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    create_before_destroy = true
  }
}