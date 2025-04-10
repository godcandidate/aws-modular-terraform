variable "state_bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state files"
  type        = string
  default     = "terraform-state-files-qr-app"
}

variable "ec2_locks_table_name" {
  description = "Name of the DynamoDB table for EC2 deployment state locking"
  type        = string
  default     = "terraform-locks-ec2"
}

variable "eks_locks_table_name" {
  description = "Name of the DynamoDB table for EKS deployment state locking"
  type        = string
  default     = "terraform-locks-eks"
}

variable "deployment_type" {
  description = "Type of deployment: 'ec2' or 'eks'"
  type        = string
}