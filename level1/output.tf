output "env_code" {
  value = var.env_code
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public-subnet_id" {
  value = aws_subnet.public.*.id
}

output "public-subnet_id2" {
  value = aws_subnet.public[1].id
}

output "private-subnet_id" {
  value = aws_subnet.private.*.id
}

output "private-subnet_id2" {
  value = aws_subnet.private[1].id
}
