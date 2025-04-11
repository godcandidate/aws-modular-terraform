# VPC Module
module "vpc" {
  source = "./modules/vpc"

  environment  = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = var.vpc_cidr

  depends_on = [module.vpc]
}

# EC2 Instance Module
module "ec2" {
  source = "./modules/ec2"

  environment      = var.environment
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_groups.security_group_id
  ssh_key_name    = var.ssh_key_name
  docker_image    = var.docker_image
}

# Outputs
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}
