

module "aws" {
  source = "../../../terraform/module/aws/application"

  environment = local.environment
  organization = local.organization
  default_tags = local.default_tags

  target_regions = local.target_regions
  aws = local.aws

  subdomains = ["api"]
  namespaces = ["api"]
  top_level_domain = local.top_level_domain
}