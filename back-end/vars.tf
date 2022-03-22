variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  type        = string
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

#data "terraform_remote_state" "s3" {
#  backend = "s3"
#}