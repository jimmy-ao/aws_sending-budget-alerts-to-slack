#  providers

# This provider will the main one

provider "aws" {
  region  = var.region
  profile = var.profile
}