resource "aws_api_gateway_domain_name" "example" {
  domain_name              = "${var.sandbox_id}.${var.base_domain}"
  regional_certificate_arn = var.acm_cert_arn

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

data "aws_route53_zone" "example" {
  name         = var.base_domain
  private_zone = false
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.example.id
  domain_name = aws_api_gateway_domain_name.example.domain_name
}