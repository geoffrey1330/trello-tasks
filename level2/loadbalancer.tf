resource "aws_security_group" "lb-sg" {
  name   = "${var.env_code}-lb-sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["105.112.100.127/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app-lb" {
  name               = "${var.env_code}-lb"
  internal           = false
  load_balancer_type = "application"
  
  tags = {
     Name = "${var.env_code}-lb"
  }
}
