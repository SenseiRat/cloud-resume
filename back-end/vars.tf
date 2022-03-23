data "aws_caller_identity" "current" {}

variable "common_tags" {
  description = "Common tags applied to all components"
  default = {
    Project = "cloud-resume"
  }
}

variable "aws_access_key" {
  type    = string
  default = "$env:TF_VAR_aws_access_key_id"
  sensitive = true
}

variable "aws_secret_key" {
  type    = string
  default = "$env:TF_VAR_aws_secret_access_key"
  sensitive = true
}

variable "aws_region" {
  type        = string
  default     = "$env:TF_VAR_aws_region"
  description = "Region for region-specific resources"
}

variable "backend_bucket" {
  type        = string
  default     = "$env:TF_VAR_backend_bucket"
  description = "The name of the bucket used for the backend"
}

variable "resume_bucket" {
  type        = string
  description = "The S3 bucket used to host the website"
  default     = "$env:TF_VAR_resume_bucket"
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "The Cloudfront distribution ID"
  default     = "$env:TF_VAR_cloudfront_distribution_id"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDB Table that the lambda interacts with"
  default     = "$env:TF_VAR_dynamodb_table_name"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
  default     = "$env:TF_VAR_domain_name"
}

variable "cicd-resume-policy" {
  type        = string
  description = "Stored because we can't call an object within itself"
  default     = "$env:TF_VAR_cicd-resume-policy"
}