resource "aws_instance" "Nginx" {
  ami = var.env.ami
  instance_type = var.env.instance_type
  subnet_id = var.env.subnet_id
  key_name = var.env.key_name
  user_data = var.env.user_data
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.env.env}-Nginx"
  }
}

resource "aws_security_group" "sg" {
  vpc_id = var.env.aws_vpc
  tags = {
    Name = "${terraform.workspace}-sg"
  }
}

resource "aws_security_group_rule" "http" {
  type = "ingress"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [var.env.public_cidr]
  from_port = 80
  protocol = "tcp"
  to_port = 80
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  protocol = "tcp"
  to_port = 22
}
