locals {
  name   = "vault-${terraform.workspace}"
  bucket = "red-devops-terraform-state"

  tags = {
    Name        = local.name
    Create      = "terraform"
    Environment = terraform.workspace
    Team        = var.team
  }

  allow_https = {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow https"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }

  allow_http = {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow http"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }

  allow_ssh = {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow ssh"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }

  allow_8200 = {
    from_port        = 8200
    to_port          = 8200
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow 8200"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }

  allow_8201 = {
    from_port        = 8201
    to_port          = 8201
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow 8201"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }

  allow_all = {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow http"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }
}