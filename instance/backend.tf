
terraform {
  backend "s3" {
    bucket         = "israel-terraform"
    key            = "trello/Instance/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}
