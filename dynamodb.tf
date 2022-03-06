resource "aws_dynamodb_table" "resume-visit-counter" {
  name         = "Cloud-Resume-Visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pkey"
  range_key    = "visitors"
  table_class  = "STANDARD_INFREQUENT_ACCESS"

  attribute {
    name = "pkey"
    type = "S"
  }

  attribute {
    name = "visitors"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "resume-visit-count-init" {
  table_name = aws_dynamodb_table.resume-visit-counter.name
  hash_key   = aws_dynamodb_table.resume-visit-counter.hash_key
  range_key  = aws_dynamodb_table.resume-visit-counter.range_key

  item = <<ITEM
{
    "pkey": {"S": "visitors"},
    "num_visits": {"N": "0"}
}
ITEM
}