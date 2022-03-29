resource "github_actions_secret" "AWS_REGION" {
  repository      = var.repository_name
  secret_name     = "AWS_REGION"
  plaintext_value = data.aws_region.current.name
}

resource "github_actions_secret" "BACKEND_BUCKET" {
  repository      = var.repository_name
  secret_name     = "BACKEND_BUCKET"
  plaintext_value = var.backend_bucket
}

resource "github_actions_secret" "CF_DIST_ID" {
  repository      = var.repository_name
  secret_name     = "CF_DIST_ID"
  plaintext_value = aws_cloudfront_distribution.resume-distribution.id
}

resource "github_actions_secret" "CICD_RESUME_POLICY" {
  repository      = var.repository_name
  secret_name     = "CICD_RESUME_POLICY"
  plaintext_value = aws_iam_policy.resume-cicd-policy.arn
}

resource "github_actions_secret" "DOMAIN_NAME" {
  repository      = var.repository_name
  secret_name     = "DOMAIN_NAME"
  plaintext_value = var.domain_name
}

resource "github_actions_secret" "RESUME_BUCKET" {
  repository      = var.repository_name
  secret_name     = "RESUME_BUCKET"
  plaintext_value = aws_s3_bucket.resume-bucket.id
}