output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IPv4 address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IPv4 address, if one was assigned."
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "ID of the module-created security group, or null when disabled."
  value       = try(aws_security_group.this[0].id, null)
}
