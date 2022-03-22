resource "aws_iam_user" "resume-cicd" {
  name = "resume-cicd"
  path = "/"

  tags = var.common_tags
}

resource "aws_iam_group" "resume-cicd-group" {
  name = "ResumeCiCDPerms"
  path = "/"
}

resource "aws_iam_user_group_membership" "resume-cicd-user-membership" {
  user = aws_iam_user.resume-cicd.name

  groups = [aws_iam_group.resume-cicd-group.name]
}

data "aws_iam_policy_document" "resume-cicd-policy-document" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      "${aws_s3_bucket.resume-bucket.arn}",
      "${aws_s3_bucket.resume-bucket.arn}/*"
    ]
  }

  statement {
    sid    = "AllowCF"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      "${aws_cloudfront_distribution.resume-distribution.arn}"
    ]
  }

  statement {
    sid    = "AllowTFBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "$arn:aws:s3:::${var.backend_bucket}"
    ]
  }

  statement {
    sid    = "AllowTFObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "$arn:aws:s3:::${var.backend_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "resume-cicd-policy" {
  name        = "ResumeCiCDPermissions"
  path        = "/"
  description = "Policy to allow CICD pipelines permissions to required resources"
  policy      = data.aws_iam_policy_document.resume-cicd-policy-document.json

  tags = var.common_tags
}

resource "aws_iam_group_policy_attachment" "resume-cicd-policy-attachment" {
  group      = aws_iam_group.resume-cicd-group.name
  policy_arn = aws_iam_policy.resume-cicd-policy.arn
}