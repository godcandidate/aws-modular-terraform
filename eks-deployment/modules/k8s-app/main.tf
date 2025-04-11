# Kubernetes deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "qr-code-app"
    namespace = "default"
  }

  spec {
    replicas = 1

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
