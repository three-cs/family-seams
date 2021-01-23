locals {
  environment = var.environment
  organization = var.organization
  default_tags = var.default_tags
  
  target_regions = var.target_regions
  aws = var.aws

  application = var.application
  namespaces = concat([var.application], var.namespaces)
  subdomains = concat([var.application], var.subdomains)

  region_modules = concat(
    module.us_east_1,
    module.us_east_2,
    module.us_west_1,
    module.us_west_2
  )

  # For collation of region specific data appropreate for an application
  # regions = { for mod in local.region_modules: mod.region => {
  #     "region" = mod.region
  #   }}

  subdomains = { for sub, zone in aws_route53_zone.subdomain:
    sub => {
      domain = zone.name
      hosted_zone_id = zone.zone_id
    }}
}