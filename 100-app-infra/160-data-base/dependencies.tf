terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      version = "~> 5.0"
    }
    vault = {
      version = "~> 3.1"
    }
  }
  backend "s3" {
    key = "data-base.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = local.bucket
    key    = "env:/${terraform.workspace}/network.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket = local.bucket
    key    = "env:/${terraform.workspace}/security-group.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "vault_instance" {
  backend = "s3"
  config = {
    bucket = local.bucket
    key    = "env:/${terraform.workspace}/vault-instance.tfstate"
    region = var.region
  }
}

data "aws_secretsmanager_secret_version" "cicd_vault_token" {
  secret_id = "cicd-vault-${terraform.workspace}-token"
}

provider "aws" {
  region = var.region
}

provider "vault" {
  address = "http://${data.terraform_remote_state.vault_instance.outputs.vault_private_ip}:8200"
  token   = jsondecode(data.aws_secretsmanager_secret_version.cicd_vault_token.secret_string)["cicd-token"]
}
