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

module "backend_asg" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling.git"
  name   = "${local.name}-backend-ASG"

  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnets
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  image_id          = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  target_group_arns = module.backend_alb.target_group_arns
  security_groups   = [data.terraform_remote_state.security_group.outputs.backend_ec2_sg_id]

  tags = local.tags
}

module "backend_alb" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git"

  name = "${local.name}-backend-ALB"

  load_balancer_type = "application"

  vpc_id                = data.terraform_remote_state.network.outputs.vpc_id
  subnets               = data.terraform_remote_state.network.outputs.public_subnets
  create_security_group = false
  security_groups       = [data.terraform_remote_state.security_group.outputs.backend_alb_sg_id]

  http_tcp_listeners = [
    {
      port     = 8080
      protocol = "HTTP"
    },
  ]

  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/actuator/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      tags             = local.tags
    },
  ]

  tags = local.tags

}

module "frontend_asg" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling.git"
  name   = "${local.name}-frontend-ASG"

  vpc_zone_identifier = data.terraform_remote_state.network.outputs.public_subnets
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  image_id          = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  target_group_arns = module.frontend_alb.target_group_arns
  security_groups   = [data.terraform_remote_state.security_group.outputs.frontend_ec2_sg_id]

  tags = local.tags
}

module "frontend_alb" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git"

  name = "${local.name}-frontend-ALB"

  load_balancer_type = "application"

  vpc_id                = data.terraform_remote_state.network.outputs.vpc_id
  subnets               = data.terraform_remote_state.network.outputs.public_subnets
  security_groups       = [data.terraform_remote_state.security_group.outputs.frontend_alb_sg_id]
  create_security_group = false

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/temp/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      tags             = local.tags
    },
  ]

  tags = local.tags
}
