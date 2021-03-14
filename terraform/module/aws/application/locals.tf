locals {
  environment  = var.environment
  organization = var.organization
  default_tags = var.default_tags

  target_regions = var.target_regions
  aws            = var.aws

  application              = var.application
  namespaces               = setunion([var.application], var.namespaces)
  subdomains               = setunion([var.application], var.subdomains)
  subdomain_load_balancers = var.subdomain_load_balancers

  region_modules = concat(
    module.us_east_1,
    module.us_east_2,
    module.us_west_1,
    module.us_west_2
  )

  domains = { for subdomain, record in aws_route53_record.subdomain : subdomain => record.name }
}