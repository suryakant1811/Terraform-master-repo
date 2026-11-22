locals {
  description = coalesce(var.description, "Security group for ${var.name}")

  ingress_security_groups = {
    for index, rule in var.ingress_rules : tostring(index) => distinct(compact(concat(
      coalesce(rule.source_security_group_ids, []),
      rule.source_security_group_id != null ? [rule.source_security_group_id] : [],
    )))
  }

  egress_security_groups = {
    for index, rule in var.egress_rules : tostring(index) => distinct(compact(concat(
      coalesce(rule.source_security_group_ids, []),
      rule.source_security_group_id != null ? [rule.source_security_group_id] : [],
    )))
  }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = local.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = { for index, rule in var.ingress_rules : tostring(index) => rule }

    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(ingress.value.prefix_list_ids) > 0 ? ingress.value.prefix_list_ids : null
      security_groups  = length(local.ingress_security_groups[ingress.key]) > 0 ? local.ingress_security_groups[ingress.key] : null
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.allow_all_egress ? { all = true } : { for index, rule in var.egress_rules : tostring(index) => rule }

    content {
      description = egress.key == "all" ? "Allow all outbound traffic" : egress.value.description

      from_port = egress.key == "all" ? 0 : egress.value.from_port
      to_port   = egress.key == "all" ? 0 : egress.value.to_port
      protocol  = egress.key == "all" ? "-1" : egress.value.protocol

      cidr_blocks = egress.key == "all" ? ["0.0.0.0/0"] : (
        length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      )
      ipv6_cidr_blocks = egress.key == "all" ? ["::/0"] : (
        length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      )
      prefix_list_ids = egress.key == "all" ? null : (
        length(egress.value.prefix_list_ids) > 0 ? egress.value.prefix_list_ids : null
      )

      security_groups = egress.key == "all" ? null : (
        length(local.egress_security_groups[egress.key]) > 0 ? local.egress_security_groups[egress.key] : null
      )
      self = egress.key == "all" ? false : egress.value.self
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    create_before_destroy = true
  }
}