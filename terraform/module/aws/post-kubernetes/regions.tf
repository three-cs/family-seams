module "us_east_1" {
  source = "./region"
  count  = contains(local.target_regions, "us-east-1") ? 1 : 0

  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  providers = {
    aws        = aws.us_east_1
    kubernetes = kubernetes.us_east_1
  }
}

module "us_east_2" {
  source = "./region"
  count  = contains(local.target_regions, "us-east-2") ? 1 : 0

  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  providers = {
    aws        = aws.us_east_2
    kubernetes = kubernetes.us_east_2
  }
}

module "us_west_1" {
  source = "./region"
  count  = contains(local.target_regions, "us-west-1") ? 1 : 0

  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  providers = {
    aws        = aws.us_west_1
    kubernetes = kubernetes.us_west_1
  }
}

module "us_west_2" {
  source = "./region"
  count  = contains(local.target_regions, "us-west-2") ? 1 : 0

  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  providers = {
    aws        = aws.us_west_2
    kubernetes = kubernetes.us_west_2
  }
}