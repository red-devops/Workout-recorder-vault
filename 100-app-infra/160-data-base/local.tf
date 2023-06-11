locals {
  name                       = "DB-${terraform.workspace}"
  bucket                     = "red-devops-terraform-state"
  db_name                    = "workoutrecorder"
  db_admin                   = "dbadmin"
  secret_name_admin_password = "data-base-admin-password"

  tags = {
    Name        = local.name
    Environment = terraform.workspace
    Create      = "terraform"
    Team        = var.team
  }

}
