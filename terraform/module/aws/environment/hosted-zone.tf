
resource "aws_route53_zone" "environment_subdomain" {
  count = local.create_environment_domain ? 1 : 0
  name  = "${local.environment}.${local.top_level_domain.domain}"

  tags = local.default_tags
}