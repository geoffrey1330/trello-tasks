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

# Create a new load balancer
resource "aws_elb" "app-lb" {
  
  name               = "${var.env_code}-lb"
  subnets            =  data.terraform_remote_state.networking.outputs.public-subnet_id 
  #security_groups    = [aws_security_group.lb-sg.id]
  

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 20
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.env_code}-lb"
  }
}

resource "aws_elb_attachment" "lb-attach" {
  count    = 2
  elb      = aws_elb.app-lb.id

  instance = aws_instance.web_public[count.index].id
}

