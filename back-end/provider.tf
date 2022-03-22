provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  required_version = "~> 1.1.6"

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

  backend "s3" {
    bucket = "starnes.cloud-terraform"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}