

module "aws" {
  source = "../../../terraform/module/aws/application"

  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  target_regions = local.target_regions
  aws            = local.aws
  application    = local.application

  subdomains               = [local.web.subdomain]
  subdomain_load_balancers = local.subdomain_load_balancers
  namespaces               = [local.web.namespace]
}