output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed as public-01, public-02, and so on."
  value       = { for key, subnet in aws_subnet.public : key => subnet.id }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed as private-01, private-02, and so on."
  value       = { for key, subnet in aws_subnet.private : key => subnet.id }
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDRs keyed as private-01, private-02, and so on."
  value       = { for key, subnet in aws_subnet.private : key => subnet.cidr_block }
}

output "database_subnet_ids" {
  description = "Database subnet IDs keyed as database-01, database-02, and so on."
  value       = { for key, subnet in aws_subnet.database : key => subnet.id }
}

output "database_subnet_cidrs" {
  description = "Database subnet CIDRs keyed as database-01, database-02, and so on."
  value       = { for key, subnet in aws_subnet.database : key => subnet.cidr_block }
}

output "nat_gateway_id" {
  description = "NAT gateway ID, or null when disabled."
  value       = try(aws_nat_gateway.this[0].id, null)
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}

output "database_route_table_id" {
  description = "ID of the database route table."
  value       = aws_route_table.database.id
}
