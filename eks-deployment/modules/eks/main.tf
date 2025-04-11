# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [var.cluster_security_group_id]
  }

  depends_on = [var.module_depends_on]
}

# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-managed-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  depends_on = [aws_eks_cluster.main]
}

# Kubernetes Provider Configuration
provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.main.name]
    command     = "aws"
  }
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
      app = "qr-code-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
