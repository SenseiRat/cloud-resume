data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

variable "common_tags" {
  description = "Common tags applied to all components"
  default = {
    Project = "cloud-resume"
  }
}

variable "github_owner" {
  type        = string
  description = "The account that owns the github repository"
  default     = "$env:GITHUB_OWNER"
}

variable "github_token" {
  type        = string
  description = "The PAT used to manipulate the Github action secrets"
}

variable "repository_name" {
  type        = string
  description = "Name of the repository that is being used to hold secrets"
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

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "cicd_resume_policy" {
  type        = string
  description = "Stored because we can't call an object within itself"
}

variable "ipgeo_api_key" {
  type        = string
  description = "API Key for performing Geolocation lookups in lambda"
}