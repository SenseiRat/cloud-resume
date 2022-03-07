provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 4.4.0"
    }
    archive = {
      source  = "archive"
      version = "2.2.0"
    }
  }
}