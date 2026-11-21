output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs in the same order as public_subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs in the same order as private_subnets."
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDRs in the same order as private_subnets."
  value       = aws_subnet.private[*].cidr_block
}

output "nat_gateway_id" {
  description = "NAT gateway ID, or null when disabled."
  value       = try(aws_nat_gateway.this[0].id, null)
}
