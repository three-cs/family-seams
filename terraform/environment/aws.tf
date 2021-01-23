
module "region_selector" {
  source = "../module/aws/environment"

  environment = local.environment
  organization = local.organization
  default_tags = local.default_tags
  top_level_domain = local.top_level_domain

  target_regions = var.target_regions
  base_cidr = "10.0.0.0/16"
}
