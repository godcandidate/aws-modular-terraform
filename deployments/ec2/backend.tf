# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-files-qr-app"
#     key            = "ec2-deployment/terraform.tfstate"
#     region         = "eu-west-1"
#     use_lockfile   = true
#     encrypt        = true
#   }
# }
