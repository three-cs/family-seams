module "us_east_1" {
  source = "./region"
  count  = contains(local.target_regions, "us-east-1") ? 1 : 0

  environment        = local.environment
  organization       = local.organization
  ogranization_email = local.ogranization_email
  default_tags       = local.default_tags
  aws_region         = local.aws.regions["us-east-1"]
  top_level_domain   = local.aws.top_level_domain

  cluster_issuer_access_key = aws_iam_access_key.cluster_issuer

  providers = {
    aws        = aws.us_east_1
    kubernetes = kubernetes.us_east_1
  }
}

module "us_east_2" {
  source = "./region"
  count  = contains(local.target_regions, "us-east-2") ? 1 : 0

  environment        = local.environment
  organization       = local.organization
  ogranization_email = local.ogranization_email
  default_tags       = local.default_tags
  aws_region         = local.aws.regions["us-east-2"]
  top_level_domain   = local.aws.top_level_domain

  cluster_issuer_access_key = aws_iam_access_key.cluster_issuer

  providers = {
    aws        = aws.us_east_2
    kubernetes = kubernetes.us_east_2
  }
}

module "us_west_1" {
  source = "./region"
  count  = contains(local.target_regions, "us-west-1") ? 1 : 0

  environment        = local.environment
  organization       = local.organization
  ogranization_email = local.ogranization_email
  default_tags       = local.default_tags
  aws_region         = local.aws.regions["us-west-1"]
  top_level_domain   = local.aws.top_level_domain

  cluster_issuer_access_key = aws_iam_access_key.cluster_issuer

  providers = {
    aws        = aws.us_west_1
    kubernetes = kubernetes.us_west_1
  }
}

module "us_west_2" {
  source = "./region"
  count  = contains(local.target_regions, "us-west-2") ? 1 : 0

  environment        = local.environment
  organization       = local.organization
  ogranization_email = local.ogranization_email
  default_tags       = local.default_tags
  aws_region         = local.aws.regions["us-west-2"]
  top_level_domain   = local.aws.top_level_domain

  cluster_issuer_access_key = aws_iam_access_key.cluster_issuer

  providers = {
    aws        = aws.us_west_2
    kubernetes = kubernetes.us_west_2
  }
}