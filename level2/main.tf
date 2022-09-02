terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"

  name                      = var.env_code
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 4
  health_check_grace_period = 30
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.networking.outputs.private-subnet_id
  target_group_arns         = module.loadbalancer.target_group_arns
  force_delete              = true

  launch_template_name   = var.env_code
  update_default_version = true

  image_id        = data.aws_ami.amazonlinux.id
  instance_type   = "t2.micro"
  key_name        = "main"
  security_groups = [module.external_sg.security_group_id]
  user_data       = filebase64("user-data.sh")


  create_iam_instance_profile = true
  iam_role_name               = var.env_code
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for Sessions Manager"
  iam_role_tags = {
    CustomIamRole = "No"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

module "loadbalancer" {
  source = "terraform-aws-modules/alb/aws"

  name = var.env_code

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.networking.outputs.vpc_id
  internal        = false
  subnets         = data.terraform_remote_state.networking.outputs.public-subnet_id
  security_groups = [module.external_sg.security_group_id]

  target_groups = [
    {
      name_prefix          = "main"
      backend_protocol     = "HTTP"
      backend_port         = 80
      deregistration_delay = 10

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 5
        timeout             = 5
        protocol            = "HTTP"
      }
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.cert.arn
      action_type     = "forward"
    }
  ]
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier             = var.env_code
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  port                   = "3306"
  db_name                = "mydb"
  username               = "admin"
  password               = local.rds_password
  create_random_password = false

  skip_final_snapshot = true
  multi_az            = true

  vpc_security_group_ids = [module.external_sg.security_group_id]

  backup_retention_period = 25
  backup_window           = "21:00-23:00"

  create_db_subnet_group = true
  subnet_ids             = data.terraform_remote_state.networking.outputs.private-subnet_id

  family               = "mysql5.7"
  major_engine_version = "5.7"
}
