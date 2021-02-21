
resource "aws_route53_record" "subdomain" {
  for_each = local.subdomains
  zone_id  = local.aws.top_level_domain.hosted_zone_id
  name     = "${each.value}.${local.aws.top_level_domain.domain}"
  type     = "CNAME"
  ttl      = "300"
  records  = [local.subdomain_load_balancers[each.value]]
}