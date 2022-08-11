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

module "ec2" {
  source   = "../modules/ec2"
  env_code = var.env_code

  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  public-subnet_id  = data.terraform_remote_state.networking.outputs.public-subnet_id
  private-subnet_id = data.terraform_remote_state.networking.outputs.private-subnet_id
}
