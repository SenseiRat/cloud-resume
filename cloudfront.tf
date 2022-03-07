# Create CloudFront distribution
resource "aws_cloudfront_distribution" "resume-distribution" {
  origin {
    domain_name = var.domain_name
    origin_id   = aws_s3_bucket.resume-bucket.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.resume-OAI.cloudfront_access_identity_path
    }
  }

  enabled     = true
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN", "RU"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.resume-bucket.bucket_regional_domain_name
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

# Create Original Access Identity
resource "aws_cloudfront_origin_access_identity" "resume-OAI" {
  comment = "Resume Origin Access Identity"
}