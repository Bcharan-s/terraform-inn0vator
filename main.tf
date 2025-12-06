

locals {
  user_data_files = {
    dev = "files/dev.html"
    stage = "files/stage.html"
    # key = "./files/id_rsa.pub"
  }

  env = terraform.workspace

  selected_user_data = file(local.user_data_files[terraform.workspace])
  
#   public_key = file(local.user_data_files.key)
  
  user_data = <<-EOF
  #!/bin/bash 

  set -e

  sudo apt-get update -y
  sudo apt-get install -y apache2

  systemctl enable apache2
  systemctl start apache2

  mkdir -p /var/www/html

  cat << 'HTML' > /var/www/html/index.html
  ${local.selected_user_data}

  HTML
  EOF
}

# resource "aws_key_pair" "deployer" {
#   key_name   = "public_key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

module "ec2" {
  source = "./modules/ec2"
  env = {
  ami = var.env.ami
  instance_type = var.env.instance_type
  user_data = local.user_data
  subnet_id = module.vpc.public_subnet
  # key_name = "public_key"
  public_key = var.env.public_key
  private_key =  var.env.private_key
  env = local.env
  name = var.env.name
  aws_vpc = module.vpc.aws_vpc
  public_cidr = var.env.public_cidr

 

  }
  
}

module "vpc" {
    source = "./modules/vpc"
    env = {
        cidr = var.env.cidr
        public_cidr = var.env.public_cidr
        private_cidr = var.env.private_cidr
    }
  
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
