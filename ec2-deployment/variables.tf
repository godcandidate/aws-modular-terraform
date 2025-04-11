variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "qr-app"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "labs_key"
}

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "godcandidate/qr-code-app:latest"
}

variable "ami_id" {
  description = "Ubuntu Server AMI ID"
  type        = string
  default     = "ami-0df368112825f8d8f"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
