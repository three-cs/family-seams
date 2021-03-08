locals {
  environment  = var.environment
  organization = var.organization
  default_tags = var.default_tags

  target_regions = var.target_regions

  aws = var.aws

  ogranization_email = var.ogranization_email

  region_modules = concat(
    module.us_east_1,
    module.us_east_2,
    module.us_west_1,
    module.us_west_2
  )

  regions = { for mod in local.region_modules : mod.region => {
    "region" = mod.region
  } }
}