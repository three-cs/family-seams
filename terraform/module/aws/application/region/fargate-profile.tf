module "eks_fargate" {
  source  = "terraform-module/eks-fargate-profile/aws"
  version = "2.2.6"

  cluster_name = local.aws.eks.name
  subnet_ids   = local.aws.vpc.private_subnets
  namespaces   = local.namespaces

  tags = local.default_tags
}