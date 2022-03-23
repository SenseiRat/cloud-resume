data "aws_caller_identity" "current" {}

variable "common_tags" {
  description = "Common tags applied to all components"
}

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

variable "backend_bucket" {
  type = string
  description = "The name of the bucket used for the backend"
  default = "$env:BACKEND_BUCKET"
}

variable "resume_bucket" {
  type = string
  description = "The S3 bucket used to host the website"
  default = "$env:RESUME_BUCKET"
}

variable "cloudfront_distribution_id" {
  type = string
  description = "The Cloudfront distribution ID"
  default = "$env:CF_DIST_ID"
}

variable "dynamodb_table_name" {
  type = string
  description = "The name of the DynamoDB Table that the lambda interacts with"
  default = "$env:DYNAMODB_TABLE_NAME"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
  default = "$env:DOMAIN_NAME"
}

variable "cicd-resume-policy" {
  type        = string
  description = "Stored because we can't call an object within itself"
  default = "$env:CICD_RESUME_POLICY"
}