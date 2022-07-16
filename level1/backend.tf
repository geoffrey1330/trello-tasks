terraform {
  backend "s3" {
    bucket         = "israel-terraform"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}
