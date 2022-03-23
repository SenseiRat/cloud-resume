#resource "github_actions_secret" "dynamodb_table_name" {
#  repository      = "cloud-resume"
#  secret_name     = "DYNAMODB_TABLE_NAME"
#  plaintext_value = aws_dynamodb_table.resume-visit-counter.name
#}