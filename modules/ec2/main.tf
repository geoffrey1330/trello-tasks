resource "aws_security_group" "web-sg" {
  name   = "${var.env_code}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["105.112.108.199/32", "10.0.0.0/16", "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_launch_configuration" "web_config" {
  image_id             = data.aws_ami.amazonlinux.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.lc_profile.name
  security_groups      = [aws_security_group.web-sg.id]

  user_data = <<EOF
    #!/usr/bin/env bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd && sudo systemctl enable httpd
    EOF
}
