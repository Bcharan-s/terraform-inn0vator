locals {
  user_data_files = {
    dev = "files/dev.html"
    stage = "files/stage.html"
  }

  env = terraform.workspace

  selected_user_data = file(local.user_data_files[terraform.workspace])
  
  user_data = <<EOF
  #!/bin/bash

  set -e

  apt-get update -y
  apt-get install -y apache2

  systemctl enable apache2
  systemctl start apache2

  mkdir -p /var/www/html

  cat << 'HTML' > /var/www/html/index.html
  ${local.selected_user_data}

  HTML
  EOF
}

module "ec2" {
  source = "./modules/ec2"
  env = {
  ami = var.env.ami
  instance_type = var.env.instance_type
  user_data = local.user_data
  subnet_id = module.vpc.public_subnet
  key_name = var.env.key_name
  env = local.env
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