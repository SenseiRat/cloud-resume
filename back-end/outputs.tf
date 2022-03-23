output "dynamodb_table_name" {
  value = aws_dynamodb_table.resume-visit-counter.name
}

output "resume_bucket_name" {
  value = aws_s3_bucket.resume-bucket.id
}

output "cf_dist_id" {
  value = aws_cloudfront_distribution.resume-distribution.id
}

data "aws_region" "current" {}

output "aws_region" {
  value = data.aws_region.current.name
}

output "cicd-resume-policy" {
  value = aws_iam_policy.resume-cicd-policy.arn
}