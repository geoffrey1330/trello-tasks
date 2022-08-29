data "aws_secretsmanager_secret" "secret_manager" {
  name = "MyMac/SSH"
}
