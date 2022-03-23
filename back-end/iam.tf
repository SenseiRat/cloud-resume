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
      "cloudfront:*"
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

  statement {
    sid    = "AllowCFOAI"
    effect = "Allow"
    actions = [
      "cloudfront:*"
    ]
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:origin-access-identity/${aws_cloudfront_origin_access_identity.resume-OAI.id}"
    ]
  }

  statement {
    sid    = "AllowDynamoDB"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "${aws_dynamodb_table.resume-visit-counter.arn}"
    ]
  }

  statement {
    sid    = "AllowIAM"
    effect = "Allow"
    actions = [
      "iam:*"
    ]
    resources = [
      "${aws_iam_role.resume-lambda-iam.arn}",
      "${aws_iam_policy.resume-lambda-policy.arn}",
      "${aws_iam_user.resume-cicd.arn}",
      "${aws_iam_group.resume-cicd-group.arn}",
      # We can't call the data object from within itself, so we store this as a var
      "${var.cicd-resume-policy}"
    ]
  }

  statement {
    sid     = "AllowRoute53"
    effect  = "Allow"
    actions = ["route53:*"]
    resources = [
      "${aws_route53_zone.starnes-cloud.arn}"
    ]
  }

  statement {
    sid    = "AllowACM"
    effect = "Allow"
    actions = [
      "acm:*"
    ]
    resources = [
      "${aws_acm_certificate.resume-certificate.arn}"
    ]
  }

  statement {
    sid    = "AllowLambda"
    effect = "Allow"
    actions = [
      "lambda:*"
    ]
    resources = [
      "${aws_lambda_function.resume-lambda.arn}"
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