output "env_code" {
  value = var.env_code
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public-subnet_id" {
  value = module.vpc.public-subnet_id
}

output "private-subnet_id" {
  value = module.vpc.private-subnet_id
}
