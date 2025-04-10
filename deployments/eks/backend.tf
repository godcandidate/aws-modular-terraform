terraform {
  backend "s3" {
    bucket         = "terraform-state-files-qr-app"
    key            = "eks-deployment/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-eks"
    encrypt        = true
  }
}
