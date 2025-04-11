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

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          port {
            container_port = 80
            protocol      = "TCP"
          }

          # Readiness probe - checks if the app is ready to receive traffic
          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds       = 10
            timeout_seconds     = 5
            success_threshold   = 1
            failure_threshold   = 3
          }

          # Liveness probe - checks if the app is running
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 15
            period_seconds       = 20
            timeout_seconds     = 5
            success_threshold   = 1
            failure_threshold   = 3
          }

          # Startup probe - gives the app time to start up
          startup_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds       = 5
            timeout_seconds     = 2
            success_threshold   = 1
            failure_threshold   = 30
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
