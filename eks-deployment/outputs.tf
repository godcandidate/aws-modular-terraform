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
  value       = module.k8s_app.load_balancer_hostname
}
