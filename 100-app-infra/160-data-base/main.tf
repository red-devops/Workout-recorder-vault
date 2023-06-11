resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "vault_generic_secret" "db_secret" {
  path      = "secret/kv/workoutrecorder/${terraform.workspace}/db_secret"
  data_json = <<EOT
    {
      "username": "admin",
      "password": "${random_password.db_password.result}"
    }
  EOT
}

module "db" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds.git"

  identifier           = lower("${local.name}")
  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20

  port                   = 3306
  db_name                = local.db_name
  username               = vault_generic_secret.db_secret.data["username"]
  password               = vault_generic_secret.db_secret.data["password"]
  create_random_password = false

  create_db_option_group    = false
  create_db_parameter_group = false
  apply_immediately         = true
  skip_final_snapshot       = true

  multi_az             = false
  db_subnet_group_name = data.terraform_remote_state.network.outputs.database_subnet_group

  vpc_security_group_ids = [
    data.terraform_remote_state.security_group.outputs.db_sg_id
  ]

  tags = local.tags
}
