# Create CloudFront distribution
locals {
  s3_origin_id = "ResumeOrigin"
}

resource "aws_cloudfront_distribution" "resume-distribution" {
  origin {
    domain_name = aws_s3_bucket.resume-bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.resume-OAI.cloudfront_access_identity_path
    }
  }

  enabled             = true
  price_class         = "PriceClass_100"
  default_root_object = "resume.html"
  aliases             = [var.domain_name]

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.resume-log-bucket.bucket_domain_name
    prefix          = "cloudfront/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN", "RU"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.resume-certificate.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

# Create Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "resume-OAI" {
  comment = "Resume Origin Access Identity"
}