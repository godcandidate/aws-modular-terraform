variable "state_bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state files"
  type        = string
  default     = "terraform-state-eks-qr-app"
}

variable "locks_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks-eks"
}
