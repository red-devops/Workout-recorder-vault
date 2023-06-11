module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"

  name = local.name
  cidr = "10.0.0.0/16"

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  public_subnets   = ["10.0.21.0/24", "10.0.22.0/24"]

  create_database_subnet_group  = true
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true
  manage_default_network_acl    = false

  public_inbound_acl_rules  = concat(local.network_acls["default_inbound"])
  public_outbound_acl_rules = concat(local.network_acls["default_outbound"])

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  vpc_tags = {
    Name = "vpc-${terraform.workspace}"
  }
}
