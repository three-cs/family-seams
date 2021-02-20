locals {
  region       = data.aws_region.current.name
  environment  = var.environment
  organization = var.organization
  default_tags = merge(var.default_tags, {
    "region" = local.region
  })

  aws = var.aws_region

  namespaces = var.namespaces
}