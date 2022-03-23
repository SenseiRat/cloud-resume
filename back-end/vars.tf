data "aws_caller_identity" "current" {}

variable "common_tags" {
  description = "Common tags applied to all components"
  default = {
    Project = "cloud-resume"
  }
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type        = string
  description = "Region for region-specific resources"
}

variable "backend_bucket" {
  type        = string
  description = "The name of the bucket used for the backend"
}

variable "resume_bucket" {
  type        = string
  description = "The S3 bucket used to host the website"
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "The Cloudfront distribution ID"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDB Table that the lambda interacts with"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "cicd-resume-policy" {
  type        = string
  description = "Stored because we can't call an object within itself"
}