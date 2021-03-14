locals {
  region       = data.aws_region.current.name
  environment  = var.environment
  organization = var.organization
  default_tags = merge(var.default_tags, {
    "region" = local.region
  })

  aws_region         = var.aws_region
  top_level_domain   = var.top_level_domain
  ogranization_email = var.ogranization_email

  cluster_issuer_access_key = var.cluster_issuer_access_key

  certs = regexall("(?s:-----BEGIN CERTIFICATE-----[^\\-]+-----END CERTIFICATE-----)", data.kubernetes_secret.wildcard_certificate.data["tls.crt"])
}