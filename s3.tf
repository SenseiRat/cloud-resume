# Create the S3 bucket to host the website files in
resource "aws_s3_bucket" "resume-bucket" {
  bucket_prefix = "cloud-resume-"
}

# Bucket ACL
resource "aws_s3_bucket_acl" "resume-bucket-acl" {
  bucket = aws_s3_bucket.resume-bucket.id
  acl    = "private"
}

# Bucket access policy
resource "aws_s3_bucket_public_access_block" "resume-bucket-public-access" {
  bucket = aws_s3_bucket.resume-bucket.id

  block_public_acls   = false
  block_public_policy = false
}

# bucket versioning
resource "aws_s3_bucket_versioning" "resume-versioning" {
  bucket = aws_s3_bucket.resume-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "resume-encryption" {
  bucket = aws_s3_bucket.resume-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# bucket policy document
data "aws_iam_policy_document" "allow_oai_access_to_resume_bucket" {
  statement {
    sid    = "Allow-OAI-Access-To-Bucket"
    effect = "Allow"
    principals {
      type = "AWS"
      # TODO: Change this to be the terraform resource
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2YI7VE40AGKHR"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.resume-bucket.arn}/*"
    ]
  }
}

# Bucket Policy
resource "aws_s3_bucket_policy" "resume-bucket-policy" {
  bucket = aws_s3_bucket.resume-bucket.id
  policy = data.aws_iam_policy_document.allow_oai_access_to_resume_bucket.json
}

# CORS
resource "aws_s3_bucket_cors_configuration" "resume-cors-configuration" {
  bucket = aws_s3_bucket.resume-bucket.bucket

  cors_rule {
    allowed_headers = [
      "Authorization",
      "Content-Range",
      "Accept",
      "Content-Type",
      "Origin",
      "Range"
    ]
    allowed_methods = ["GET"]
    # TODO: Change this to be the terraform resource
    allowed_origins = ["https://3em2cgu9vi.execute-api.us-east-1.amazonaws.com/resume-api"]
    expose_headers = [
      "Content-Range",
      "Content-Length",
      "ETag"
    ]
    max_age_seconds = 3000
  }
}

# lifecycle rule
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