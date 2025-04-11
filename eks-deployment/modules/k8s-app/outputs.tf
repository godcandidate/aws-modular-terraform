output "load_balancer_hostname" {
  description = "Hostname of the application load balancer"
  value       = kubernetes_service.app.status.0.load_balancer.0.ingress.0.hostname
}
