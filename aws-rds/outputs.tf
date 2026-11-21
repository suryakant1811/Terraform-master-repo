output "instance_id" {
  description = "RDS instance ID."
  value       = aws_db_instance.this.id
}

output "endpoint" {
  description = "Database connection endpoint."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Database hostname."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Database port."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "ID of the database security group."
  value       = aws_security_group.this.id
}
