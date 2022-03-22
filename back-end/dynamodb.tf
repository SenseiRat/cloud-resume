resource "aws_dynamodb_table" "resume-visit-counter" {
  name         = "Cloud-Resume-Visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ip_address"
  table_class  = "STANDARD_INFREQUENT_ACCESS"

  attribute {
    name = "ip_address"
    type = "S"
  }

  tags = var.common_tags
}

# Attributes are ip_address, visit_count, log_source, and country