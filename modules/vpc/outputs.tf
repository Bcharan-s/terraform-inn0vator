output "aws_vpc" {
    value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
}