provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
      Project     = "ec2-deployment"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}
