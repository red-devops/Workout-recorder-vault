terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}
