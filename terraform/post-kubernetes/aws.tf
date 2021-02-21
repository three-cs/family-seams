
module "region_selector" {
  source = "../module/aws/post-kubernetes"

  environment      = local.environment
  organization     = local.organization
  default_tags     = local.default_tags
  target_regions = local.target_regions
}
