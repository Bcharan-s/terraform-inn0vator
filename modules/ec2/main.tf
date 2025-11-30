resource "aws_instance" "Nginx" {
  ami = var.env.ami
  instance_type = var.env.instance_type
  subnet_id = var.env.subnet_id
  key_name = var.env.key_name
  user_data = var.env.user_data
  vpc_security_group_ids = [aws_security_group.sg.id]
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

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4 = var.env.public_cidr
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4 = var.env.public_cidr
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
