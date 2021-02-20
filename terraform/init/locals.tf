locals {
  organization = var.organization
  default_tags = {
    organization = local.organization
    purpose      = "initialization"
  }

  domain_contact = var.domain_contact

  top_level_domain = {
    "domain"         = var.domain_name
    "hosted_zone_id" = data.external.registered_domain.result.hosted_zone
  }
}