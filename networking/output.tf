output "env_code" {
  value = var.env_code
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public-subnet_id" {
  value = aws_subnet.public[0].id
}

output "private-subnet_id" {
  value = aws_subnet.private[0].id
}