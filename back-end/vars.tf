variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "common_tags" {
  description = "Common tags applied to all components"
}