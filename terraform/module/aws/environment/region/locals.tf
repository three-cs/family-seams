locals {
  region       = data.aws_region.current.name
  environment  = var.environment
  organization = var.organization
  default_tags = merge(var.default_tags, {
    "region" = local.region
  })

  cidr                    = var.cidr
  availability_zone_count = var.availability_zone_count

  availability_zones = slice(data.aws_availability_zones.available.names, 0, local.availability_zone_count)

  subnet_count = local.availability_zone_count * 2
  all_cidrs = cidrsubnets(
    local.cidr,
    [for index in range(local.subnet_count) : ceil(log(local.subnet_count, 2))]...
  )

  private_subnet_cidrs = slice(local.all_cidrs, 0, local.availability_zone_count)
  public_subnet_cidrs  = slice(local.all_cidrs, local.availability_zone_count, local.subnet_count)

  eks = var.eks
  worker_groups = [
    {
      name                 = "default-worker-group"
      instance_type        = "t2.small"
      asg_max_size         = 3
      asg_desired_capacity = 2
    }
  ]

  fargate_roles = chomp(data.local_file.aws_fargate_roles.content) == "null" ? [] : jsondecode(data.local_file.aws_fargate_roles.content)

  vpc = {
    "id"              = module.vpc.vpc_id
    "cidr"            = module.vpc.vpc_cidr_block
    "private_subnets" = module.vpc.private_subnets
    "public_subnets"  = module.vpc.public_subnets
  }

  eks_output = {
    "name"     = module.eks.cluster_id
    "arn"      = module.eks.cluster_arn
    "endpoint" = module.eks.cluster_endpoint
  }
}