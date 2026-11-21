output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by their input names."
  value       = { for key, subnet in aws_subnet.public : key => subnet.id }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by their input names."
  value       = { for key, subnet in aws_subnet.private : key => subnet.id }
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDRs keyed by their input names."
  value       = { for key, subnet in aws_subnet.private : key => subnet.cidr_block }
}

output "nat_gateway_id" {
  description = "NAT gateway ID, or null when disabled."
  value       = try(aws_nat_gateway.this[0].id, null)
}
