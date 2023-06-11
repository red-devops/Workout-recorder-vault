data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_kms_key" "kms_key" {
  key_id = var.kms_key_id
}

resource "aws_dynamodb_table" "vault_storage_table" {
  name           = "${local.name}-storage-table"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = local.tags
}

resource "aws_instance" "vault_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  subnet_id            = data.terraform_remote_state.network.outputs.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.vault_server_profile.name
  key_name             = "vault_${terraform.workspace}_key"

  vpc_security_group_ids = [
    aws_security_group.vault_server.id
  ]

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(local.tags, {
    ostype = "linux"
  })
}

resource "aws_security_group" "vault_server" {
  name        = "${local.name}-server"
  description = "Vault Server security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    local.allow_8200,
    local.allow_8201,
    local.allow_ssh
  ]
  egress = [
    local.allow_ssh,
    local.allow_http,
    local.allow_https
  ]

  tags = local.tags
}


# resource "aws_instance" "bastion" {
#   ami                         = "ami-032fcff81d6517a06"
#   instance_type               = "t3.micro"
#   subnet_id                   = data.terraform_remote_state.network.outputs.public_subnets[0]
#   key_name                    = "vault_${terraform.workspace}_key"
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

#   vpc_security_group_ids = [
#     aws_security_group.bastion_ec2.id
#   ]

#   tags = merge(local.tags, {
#     Name = "${local.name}-bastion-ec2"
#   })
# }

# resource "aws_security_group" "bastion_ec2" {
#   name        = "${local.name}-bastion-ec2"
#   description = "Bastion EC2 security group"
#   vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

#   ingress = [
#     local.allow_ssh,
#   ]

#   egress = [
#     local.allow_ssh,
#     local.allow_http,
#     local.allow_https,
#     local.allow_8200,
#   ]

#   tags = merge(local.tags, {
#     Name = "${local.name}-bastion-ec2"
#   })
# }

# resource "aws_iam_instance_profile" "bastion_profile" {
#   name = "bastion-profile"
#   role = "cicd-agent-dev-role"
# }
