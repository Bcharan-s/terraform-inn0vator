output "public_ip" {
    value = {for server,ip in aws_instance.Nginx: server => ip.public_ip}
  
}