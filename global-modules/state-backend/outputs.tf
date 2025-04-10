output "state_bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state files"
  value       = aws_s3_bucket.terraform_state.id
}

# output "ec2_locks_table_name" {
#   description = "Name of the DynamoDB table for EC2 deployment state locking"
#   value       = aws_dynamodb_table.terraform_locks_ec2[0].name
# }

output "eks_locks_table_name" {
  description = "Name of the DynamoDB table for EKS deployment state locking"
  value       = aws_dynamodb_table.terraform_locks_eks[0].name
}
