output "frontend_alb_sg_id" {
  description = "The ID of frontend alb security group"
  value       = aws_security_group.frontend_alb.id
}

output "frontend_ec2_sg_id" {
  description = "The ID of frontend ec2 security group"
  value       = aws_security_group.frontend_ec2.id
}

output "backend_alb_sg_id" {
  description = "The ID of backend alb security group"
  value       = aws_security_group.backend_alb.id
}

output "backend_ec2_sg_id" {
  description = "The ID of frontend ec2 security group"
  value       = aws_security_group.backend_ec2.id
}

output "db_sg_id" {
  description = "The ID of db security group"
  value       = aws_security_group.db.id
}

output "vault_ec2_sg_id" {
  description = "The ID of vault ec2 security group"
  value       = aws_security_group.vault_ec2.id
}

# output "bastion_ec2_sg_id" {
#   description = "The ID of bastion ec2 security group"
#   value       = aws_security_group.bastion_ec2.id
# }