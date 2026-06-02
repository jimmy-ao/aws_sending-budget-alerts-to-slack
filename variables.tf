#  variables

variable "profile" {
  type        = string
  description = "Profile used to create Terraform resources."
}

variable "region" {
  type        = string
  description = "Region used to deploy resources in."
  default     = "eu-north-1"
}

variable "environment" {
  type        = string
  description = "Resources environment."
}

