terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web-sg" {
  name   = "${var.env_code}-sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id #aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["105.112.100.127/32", "10.0.0.0/16"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["105.112.100.127/32", "10.0.0.0/16"]
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

resource "aws_instance" "web_public" {
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = "t2.micro"
  key_name               = "main"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id              = data.terraform_remote_state.networking.outputs.public-subnet_id
  user_data              = <<EOF
    #!/usr/bin/env bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd && sudo systemctl enable httpd
    EOF


  tags = {
    Name = "${var.env_code}-web-public"
  }
}

resource "aws_instance" "web_private" {
  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = "t2.micro"
  key_name               = "main"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id              = data.terraform_remote_state.networking.outputs.private-subnet_id
  user_data              = <<EOF
    #!/usr/bin/env bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd && sudo systemctl enable httpd
    EOF


  tags = {
    Name = "${var.env_code}-web-private"
  }
}
