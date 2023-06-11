locals {
  name   = "EC2-${terraform.workspace}"
  bucket = "red-devops-terraform-state"

  tags = {
    Name        = local.name
    Environment = terraform.workspace
    Create      = "terraform"
    Team        = var.team
  }
}
