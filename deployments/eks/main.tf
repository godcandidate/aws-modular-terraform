# VPC Module
module "vpc" {
  source = "../../global-modules/vpc"

  environment  = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  cluster_name = var.cluster_name
}

# Security Groups Module
module "security_groups" {
  source = "../../global-modules/security-groups"
  deployment_type = "eks"

  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = var.vpc_cidr

  depends_on = [module.vpc]
}

# State Backend
module "state_backend" {
  source = "../../global-modules/state-backend"
  deployment_type = "eks"
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = module.vpc.public_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [module.security_groups.eks_cluster_security_group_id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}

# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-managed-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = module.vpc.public_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy
  ]
}

# IAM Roles
resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "eks_nodes" {
  name = "${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policies
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Kubernetes deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "qr-code-app"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "qr-code-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "qr-code-app"
        }
      }

      spec {
        container {
          image = var.docker_image
          name  = "qr-code-app"

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [aws_eks_node_group.main]
}

resource "kubernetes_service" "app" {
  metadata {
    name = "qr-code-app"
    namespace = "default"
  }

  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

# Outputs
output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "kubeconfig_command" {
  description = "Configure kubectl: run the following command to update your kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.main.name}"
}

output "app_load_balancer" {
  description = "Load balancer hostname for the application"
  value       = kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname
}
