resource "aws_security_group" "cicd_agent" {
  name        = "${local.name}-cicd-agent"
  description = "CICD agent security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress = [
    local.allow_ssh,
    local.allow_https,
    local.allow_8200
  ]

  tags = local.tags
}

resource "aws_instance" "cicd_agent" {
  ami                  = "ami-06d343af756be7c83"
  instance_type        = "t3.micro"
  subnet_id            = data.terraform_remote_state.network.outputs.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.cicd_profile.name
  vpc_security_group_ids = [
    aws_security_group.cicd_agent.id
  ]

  lifecycle {
    prevent_destroy = false
  }

  tags = local.tags
}

resource "aws_iam_instance_profile" "cicd_profile" {
  name = "${local.name}-profile"
  role = "${local.name}-role"
}
