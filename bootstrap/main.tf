provider "aws" {
  region = "eu-west-1"
}

module "state_backend" {
  source = "../global-modules/state-backend"
}
