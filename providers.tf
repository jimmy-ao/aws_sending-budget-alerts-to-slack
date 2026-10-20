#  providers

# This provider will the main one

provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Environment = var.environment
      Location    = var.region
      ManagedBy   = "terraform"
      Project     = var.project
    }
  }
}