resource "aws_api_gateway_domain_name" "example" {
  domain_name              = "${var.sandbox_id}.${var.base_domain}"
  regional_certificate_arn = aws_acm_certificate_validation.example.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "example_apiGW" {
  name    = aws_api_gateway_domain_name.example.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.example.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
  }
}

resource "aws_acm_certificate" "example" {
  domain_name       = "${var.sandbox_id}.${var.base_domain}"
  validation_method = "DNS"
}

data "aws_route53_zone" "example" {
  name         = var.base_domain
  private_zone = false
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}