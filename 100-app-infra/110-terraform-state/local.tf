locals {
  name                = "terraform-state"
  bucket              = "red-devops-terraform-state"
  dynamodb_table_name = "red-devops-lock-table"

  tags = {
    Name = local.name
    Team = var.team
  }
}
