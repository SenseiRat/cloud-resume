variable "aws_access_key" {
  type    = string
  default = "$env:AWS_ACCESS_KEY_ID"
}
variable "aws_secret_key" {
  type    = string
  default = "$env:AWS_SECRET_ACCESS_KEY"
}

variable "aws_region" {
  type        = string
  default     = "$env:AWS_REGION"
  description = "Region for region-specific resources"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "common_tags" {
  description = "Common tags applied to all components"
}

variable "backend_bucket" {
  description = "The name of the bucket used for the backend"
}

data "aws_caller_identity" "current" {}

variable "cicd-resume-policy" {
  type        = string
  description = "Stored because we can't call an object within itself"
}