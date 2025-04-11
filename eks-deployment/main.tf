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
  module_depends_on        = [module.iam]
}

# Kubernetes Application - only create after EKS cluster is ready
module "k8s_app" {
  source = "./modules/k8s-app"
  
  docker_image = var.docker_image

  depends_on = [module.eks]
}


