output "output_values" {
    value = {
        aws_vpc = aws_vpc.vpc.id
        public_subnet = aws_subnet.public_subnet.id
        }
}