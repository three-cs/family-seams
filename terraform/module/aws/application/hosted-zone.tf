
resource "aws_route53_zone" "subdomain" {
  for_each = local.subdomains
  name = "${each.value}.${local.aws.top_level_domain.domain}"

  tags = local.default_tags
}