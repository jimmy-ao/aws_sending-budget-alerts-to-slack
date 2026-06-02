# backend

terraform {
  backend "s3" {
    profile      = ""
    bucket       = ""
    key          = "xxx/terraform.tfstate"
    region       = ""
    use_lockfile = true
  }
}