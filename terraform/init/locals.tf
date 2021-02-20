locals {
  organization = var.organization
  default_tags = {
    organization = local.organization
    purpose      = "initialization"
  }

  domain_name = var.domain_name
  # domain_contact = var.domain_contact

  top_level_domain = {
    "domain"         = local.domain_name
    "hosted_zone_id" = data.aws_route53_zone.registered_domain.zone_id
  }
}