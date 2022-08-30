variable "env_code" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public-subnet_id" {}

variable "private-subnet_id" {}

variable "domain_name" {
  default = "israeltrello.be"
  type    = string
}

variable "record_name" {
  default = "www"
  type    = string
}
