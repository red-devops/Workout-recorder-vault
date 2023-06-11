output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "The ID of public subnet"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The ID of private subnet"
  value       = module.vpc.private_subnets
}

output "database_subnet_group" {
  description = "The ID of database subnet"
  value       = module.vpc.database_subnet_group
}

output "private_subnets_cidr_blocks" {
  description = "The cidr_block of private subnet"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "database_subnets_cidr_blocks" {
  description = "The cidr_block of database subnet"
  value       = module.vpc.database_subnets_cidr_blocks
}