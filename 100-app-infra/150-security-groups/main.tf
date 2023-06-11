resource "aws_security_group" "frontend_alb" {
  name        = "${local.name}-frontend-alb"
  description = "Frontend ALB security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    local.allow_http,
    local.allow_8080
  ]
  egress = [
    local.allow_http,
    local.allow_8080
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-frontend-alb"
  })
}

resource "aws_security_group" "frontend_ec2" {
  name        = "${local.name}-frontend-ec2"
  description = "Frontend EC2 security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    local.allow_ssh,
    merge(
      local.allow_http,
      { security_groups = [aws_security_group.frontend_alb.id] }
    )
  ]

  egress = [
    local.allow_http,
    local.allow_https,
    local.allow_8080
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-frontend-ec2"
  })
}

resource "aws_security_group" "backend_alb" {
  name        = "${local.name}-backend-alb"
  description = "Backend ALB security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    merge(
      local.allow_8080,
      { security_groups = [aws_security_group.frontend_alb.id] }
    )
  ]

  egress = [
    local.allow_http,
    local.allow_https,
    local.allow_8080
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-backend-alb"
  })
}

resource "aws_security_group" "backend_ec2" {
  name        = "${local.name}-backend-ec2"
  description = "Backend EC2 security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    local.allow_ssh,
    merge(
      local.allow_8080,
      { security_groups = [aws_security_group.backend_alb.id] }
    )
  ]

  egress = [
    local.allow_http,
    local.allow_https,
    merge(
      local.allow_mysql,
      { security_groups = [aws_security_group.db.id] }
    )
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-backend-ec2"
  })
}

resource "aws_security_group" "db" {
  name        = "${local.name}-db"
  description = "DB security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  tags = merge(local.tags, {
    Name = "${local.name}-db"
  })
}

resource "aws_security_group_rule" "db_ingress" {
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = aws_security_group.backend_ec2.id
}

resource "aws_security_group_rule" "db_egress" {
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = aws_security_group.backend_ec2.id
}

resource "aws_security_group" "vault_ec2" {
  name        = "${local.name}-vault-ec2"
  description = "Vault EC2 security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    local.allow_ssh,
    local.allow_8200,
  ]

  egress = [
    local.allow_http,
    local.allow_https,
  ]

  tags = merge(local.tags, {
    Name = "${local.name}-vault-ec2"
  })
}
