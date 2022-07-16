
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = "israel-terraform"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}
