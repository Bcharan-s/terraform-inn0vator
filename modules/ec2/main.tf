resource "aws_instance" "Nginx" {
  for_each = toset(var.env.name)
  ami = var.env.ami
  instance_type = var.env.instance_type
  subnet_id = var.env.subnet_id
  key_name = "public_key"
  user_data = var.env.user_data
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "${each.value}-Nginx"
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "echo USERDATA FINISHED"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.env.private_key)
      host        = self.public_ip
    }
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "public_key"
  public_key = file(var.env.public_key)
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
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  protocol = "tcp"
  to_port = 80
}

resource "aws_security_group_rule" "http1" {
  type = "egress"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  protocol = "tcp"
  to_port = 22
}
