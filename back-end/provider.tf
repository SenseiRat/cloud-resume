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

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "starnes.cloud-terraform"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "resume_terraform_locks"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}