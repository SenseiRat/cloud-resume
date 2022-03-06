resource "aws_route53_zone" "starnes-cloud" {
    name = var.domain_name
}

resource "aws_route53_record" "starnes-cloud-root-record" {
    zone_id = aws_route53_zone.starnes-cloud.zone_id
    name = "starnes.cloud"
    type = "A"
    
    alias {
        name = aws_cloudfront_distribution.resume-distribution.domain_name
        zone_id = aws_cloudfront_distribution.resume-distribution.hosted_zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "starnes-cloud-www-record" {
    zone_id = aws_route53_zone.starnes-cloud.zone_id
    name = "www.starnes.cloud"
    type = "CNAME"
    ttl = "300"
    records = [aws_route53_record.starnes-cloud-root-record.fqdn]
}

resource "aws_acm_certificate" "resume-certificate" {
    domain_name = var.domain_name
    validation_method = "DNS"
}

resource "aws_route53_record" "resume-certificate-validation-record" {
    for_each = {
        for dvo in aws_acm_certificate.resume-certificate.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = aws_route53_zone.starnes-cloud.zone_id
}

resource "aws_acm_certificate_validation" "resume-certificate-validation" {
    certificate_arn = aws_acm_certificate.resume-certificate.arn
    validation_record_fqdns = [
        for record in aws_route53_record.resume-certificate-validation-record : record.fqdn
    ]
}