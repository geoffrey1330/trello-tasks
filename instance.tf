
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


resource "aws_instance" "web_public" {
  count                  = length(local.public_cidr)

  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  key_name               = "${var.env_code}-keypair"

  vpc_security_group_ids = [aws_security_group.web-sg.id]

  subnet_id              = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.env_code}-web"
  }
}



resource "aws_instance" "web_private" {
  count                  = length(local.public_cidr)
  
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  key_name               = "${var.env_code}-keypair"

  vpc_security_group_ids = [aws_security_group.web-sg.id]

  subnet_id              = aws_subnet.private[count.index].id

  tags = {
    Name = "${var.env_code}-web"
  }
}