resource "aws_security_group" "web-sg" {
  name = "${var.env_code}-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

resource "aws_instance" "web_public" {
 
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "main"

  vpc_security_group_ids = [aws_security_group.web-sg.id]

  subnet_id              = aws_subnet.public.id

  tags = {
    Name = "${var.env_code}-web"
  }
}


resource "aws_instance" "web_private" {
  
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "main"

  vpc_security_group_ids = [aws_security_group.web-sg.id]

  subnet_id              = aws_subnet.private.id

  tags = {
    Name = "${var.env_code}-web"
  }
}
