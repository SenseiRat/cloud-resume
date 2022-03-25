# Create the S3 bucket for holding logs
resource "aws_s3_bucket" "resume-log-bucket" {
  bucket_prefix = "cloud-resume-logs-"

  tags = var.common_tags
}

resource "aws_s3_bucket_acl" "resume-log-acl" {
  bucket = aws_s3_bucket.resume-log-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "resume-log-bucket-public-access" {
  bucket = aws_s3_bucket.resume-log-bucket.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resume-log-encryption" {
  bucket = aws_s3_bucket.resume-log-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "resume-log-bucket-policy" {
  statement {
    sid    = "AllowTF"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.resume-cicd.arn]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.resume-log-bucket.arn}",
      "${aws_s3_bucket.resume-log-bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "resume-log-bucket-policy" {
  bucket = aws_s3_bucket.resume-log-bucket.id
  policy = data.aws_iam_policy_document.resume-log-bucket-policy.json
}

# log retention policy
resource "aws_s3_bucket_lifecycle_configuration" "bucket-log-lifecycle" {
  bucket = aws_s3_bucket.resume-log-bucket.bucket

  rule {
    filter {}

    id     = "remove-old-logs"
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}

# Create the S3 bucket to host the website files in
resource "aws_s3_bucket" "resume-bucket" {
  bucket_prefix = "cloud-resume-"

  tags = var.common_tags
}

resource "aws_s3_bucket_acl" "resume-bucket-acl" {
  bucket = aws_s3_bucket.resume-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "resume-bucket-public-access" {
  bucket = aws_s3_bucket.resume-bucket.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_versioning" "resume-versioning" {
  bucket = aws_s3_bucket.resume-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resume-encryption" {
  bucket = aws_s3_bucket.resume-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "allow_oai_access_to_resume_bucket" {
  statement {
    sid    = "Allow-OAI-Access-To-Bucket"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.resume-OAI.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.resume-bucket.arn}/*"
    ]
  }

  statement {
    sid    = "AllowTF"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.resume-cicd.arn]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.resume-bucket.arn}",
      "${aws_s3_bucket.resume-bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "resume-bucket-policy" {
  bucket = aws_s3_bucket.resume-bucket.id
  policy = data.aws_iam_policy_document.allow_oai_access_to_resume_bucket.json
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  depends_on = [aws_s3_bucket_versioning.resume-versioning]
  bucket     = aws_s3_bucket.resume-bucket.bucket

  rule {
    filter {}

    id     = "remove-old-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 30
    }
  }
}

resource "aws_s3_bucket_logging" "resume-bucket-logging" {
  bucket = aws_s3_bucket.resume-bucket.id

  target_bucket = aws_s3_bucket.resume-log-bucket.id
  target_prefix = "s3/"
}

resource "aws_s3_bucket_website_configuration" "resume-website" {
  bucket = aws_s3_bucket.resume-bucket.id

  index_document {
    suffix = "resume.html"
  }

  error_document {
    key = "error.html"
  }
}

# Deploy our files to the S3 bucket
resource "aws_s3_object" "resume-html" {
  bucket       = aws_s3_bucket.resume-bucket.id
  key          = "resume.html"
  source       = "./front-end/resume.html"
  content_type = "text/html"

  tags = var.common_tags
}

resource "aws_s3_object" "resume-css" {
  bucket       = aws_s3_bucket.resume-bucket.id
  key          = "resume.css"
  source       = "./front-end/resume.css"
  content_type = "text/css"

  tags = var.common_tags
}

resource "aws_s3_object" "resume-error" {
  bucket       = aws_s3_bucket.resume-bucket.id
  key          = "error.html"
  source       = "./front-end/error.html"
  content_type = "text/html"

  tags = var.common_tags
}