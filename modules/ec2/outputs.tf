output "public_ip" {
    value = aws_instance.Nginx.public_ip 
  
}