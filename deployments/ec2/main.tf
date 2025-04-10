# VPC Module
module "vpc" {
  source = "../../global-modules/vpc"


  environment  = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  cluster_name = var.environment # Using environment as cluster_name since EKS is not used
}

# Security Groups Module
module "security_groups" {
  source = "../../global-modules/security-groups"
  deployment_type = "ec2"

  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = var.vpc_cidr

  depends_on = [module.vpc]
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.security_groups.ec2_security_group_id]
  key_name              = var.ssh_key_name

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    docker_image = var.docker_image
  })

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.environment}-instance"
  }
}

# State Backend
module "state_backend" {
  source = "../../global-modules/state-backend"
}

# Outputs
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}
