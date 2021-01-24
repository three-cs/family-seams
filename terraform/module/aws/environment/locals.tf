locals {
  environment  = var.environment
  organization = var.organization
  default_tags = var.default_tags

  eks_cluster_name = "${local.organization}-${local.environment}"

  target_regions = tolist(var.target_regions)

  base_cidr = var.base_cidr
  all_cidrs = (length(local.target_regions) == 1
    ? [local.base_cidr]
    : cidrsubnets(
      local.base_cidr,
      [for region in local.target_regions : ceil(log(length(local.target_regions), 2))]...
  ))
  cidrs_by_region = (length(local.target_regions) == 1
    ? { for region in local.target_regions :
      region => local.base_cidr
    }
    : { for region in local.target_regions :
      region => local.all_cidrs[index(local.target_regions, region)]
  })

  top_level_domain          = var.top_level_domain
  create_environment_domain = local.environment != "production"
  regions_top_level_domain = (local.create_environment_domain
    ? {
      "domain"         = aws_route53_zone.environment_subdomain[0].name
      "hosted_zone_id" = aws_route53_zone.environment_subdomain[0].zone_id
    }
  : local.top_level_domain)

  region_modules = concat(
    module.us_east_1,
    module.us_east_2,
    module.us_west_1,
    module.us_west_2
  )

  regions = { for mod in local.region_modules : mod.region => {
    "region" = mod.region
    "vpc"    = mod.vpc
    "eks"    = mod.eks
  } }
}