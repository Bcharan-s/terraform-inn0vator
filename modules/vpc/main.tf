resource "aws_vpc" "vpc" {
  cidr_block = var.env.cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.env.public_cidr
  map_public_ip_on_launch = true
  depends_on = [ aws_vpc.vpc ]
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.env.private_cidr
    depends_on = [ aws_vpc.vpc ]
    tags = {
      Name = "private_subnet"
    }
  
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
    depends_on = [ aws_vpc.vpc,aws_subnet.public_subnet ]
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "route_table"
  }
  depends_on = [ aws_internet_gateway.gw,aws_vpc.vpc ]
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.route_table.id
    depends_on = [ aws_subnet.public_subnet,aws_route_table.route_table]
}

