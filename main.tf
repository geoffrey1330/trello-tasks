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
  source   = "./modules/vpc"
  env_code = var.env_code

}

module "ec2" {
  source            = "./modules/ec2"
  env_code          = var.env_code
  vpc_id            = module.vpc.vpc_id
  public-subnet_id  = module.vpc.public-subnet_id
  private-subnet_id = module.vpc.private-subnet_id
}