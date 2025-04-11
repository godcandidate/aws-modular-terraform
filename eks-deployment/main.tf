# VPC Module
module "vpc" {
  source = "./modules/vpc"

  environment  = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  cluster_name = var.cluster_name
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  environment = var.environment
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  environment = var.environment
  vpc_id     = module.vpc.vpc_id
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  environment              = var.environment
  cluster_name             = var.cluster_name
  kubernetes_version       = var.kubernetes_version
  cluster_role_arn         = module.iam.cluster_role_arn
  node_role_arn            = module.iam.node_role_arn
  subnet_ids               = module.vpc.public_subnet_ids
  cluster_security_group_id = module.security_groups.eks_cluster_security_group_id
  instance_type            = var.instance_type
  desired_size             = var.desired_size
  max_size                 = var.max_size
  min_size                 = var.min_size
  docker_image             = var.docker_image
  module_depends_on        = [module.iam]
}

# Outputs
output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "kubeconfig_command" {
  description = "Configure kubectl: run the following command to update your kubeconfig"
  value       = module.eks.kubeconfig_command
}

output "app_load_balancer" {
  description = "Load balancer hostname for the application"
  value       = module.eks.app_load_balancer
}
