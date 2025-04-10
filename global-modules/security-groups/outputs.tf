output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = length(aws_security_group.ec2) > 0 ? aws_security_group.ec2[0].id : null
}

output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = length(aws_security_group.eks_cluster) > 0 ? aws_security_group.eks_cluster[0].id : null
}

output "eks_nodes_security_group_id" {
  description = "ID of the EKS nodes security group"
  value       = length(aws_security_group.eks_nodes) > 0 ? aws_security_group.eks_nodes[0].id : null
}
