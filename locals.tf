# locals

locals {
  common_tags = {
    Environment = var.environment
    Location    = data.aws_region.current.region
    ManagedBy   = "terraform"
    Project     = "ecs-cluster"
  }
}