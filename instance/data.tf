
data "terrafrom_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = "israel-terraform"
    key            = "trello/networking/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}