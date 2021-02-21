locals {
  region       = data.aws_region.current.name
  environment  = var.environment
  organization = var.organization
  default_tags = merge(var.default_tags, {
    "region" = local.region
  })

  aws_region = var.aws_region
}