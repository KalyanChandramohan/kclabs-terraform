resource "aws_security_group" "bastion_security_group" {
  name        = "${var.env_name}-bastion-security-group"
  description = "Linux SSH & HTTP SG"

  vpc_id = aws_vpc.devlopment_vpc.id

  tags = {
    Name = "${var.env_name}-bastion-security-group"
    Env  = var.env_name
  }


  ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
