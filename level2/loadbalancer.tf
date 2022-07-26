resource "aws_security_group" "lb-sg" {
  name   = "${var.env_code}-lb-sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["105.112.102.210/32"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_lb" "app-lb" {
#   name               = "${var.env_code}-lb"
#   internal           = false
#   load_balancer_type = "application"
  
#   tags = {
#      Name = "${var.env_code}-lb"
#   }
# }

# # Create a new load balancer attachment
# resource "aws_elb_attachment" "lb-attach" {
#   elb      = aws_lb.app-lb.id
#   instance = aws_instance.web_public.id
# }


# Create a new load balancer
resource "aws_elb" "app-lb" {
  name               = "${var.env_code}-lb"
  subnets            = [data.terraform_remote_state.networking.outputs.public-subnet_id,data.terraform_remote_state.networking.outputs.private-subnet_id]
  security_groups    = [aws_security_group.lb-sg.id]
  #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTP:80/"
  #   interval            = 30
  # }

  instances                   = [aws_instance.web_public.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.env_code}-lb"
  }
}