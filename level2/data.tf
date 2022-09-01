
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = "israel-terraform"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}

data "aws_secretsmanager_secret" "rds_password" {
  name = "rds/password"
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}

locals {
  rds_password = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["password"]
}
