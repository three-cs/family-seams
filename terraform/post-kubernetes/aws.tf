
module "region_selector" {
  source = "../module/aws/post-kubernetes"

  environment      = local.environment
  organization     = local.organization
  ogranization_email = local.ogranization_email
  default_tags     = local.default_tags
  target_regions = local.target_regions
  aws = local.aws
}
