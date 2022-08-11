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

module "vpc" {
  source         = "../modules/vpc"
  env_code       = var.env_code
  vpc            = var.vpc
  public-subnet  = var.public-subnet
  private-subnet = var.private-subnet
}
