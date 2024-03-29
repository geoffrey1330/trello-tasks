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

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "${var.env_code}-vpc"
  cidr               = var.vpc
  azs                = data.aws_availability_zones.available.names[*]
  private_subnets    = var.private-subnet
  public_subnets     = var.public-subnet
  enable_nat_gateway = true
}
