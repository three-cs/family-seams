data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = "${local.organization}-${local.environment}-vpc"
  cidr = local.cidr

  azs             = local.availability_zones
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Single NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = true

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR DKR
  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for KMS
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Default security group
  manage_default_security_group = true
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#ingress-block
  default_security_group_ingress = [
    {
      "cidr_blocks" = "0.0.0.0/0"
      "description" = "HTTP Ingress"
      "from_port"   = 80
      "to_port"     = 80
      "protocol"    = "tcp"
    },
    {
      "cidr_blocks" = "0.0.0.0/0"
      "description" = "HTTPS Ingress"
      "from_port"   = 443
      "to_port"     = 443
      "protocol"    = "tcp"
    }
  ]
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#egress-block
  default_security_group_egress = [{
    "cidr_blocks" = "0.0.0.0/0"
    "description" = "Allow All Egress"
  }]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.default_tags

  # EKS Subnet Tagging
  # https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/
  private_subnet_tags = {
    ("kubernetes.io/cluster/${local.eks_cluster_name}") = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnet_tags = {
    ("kubernetes.io/cluster/${local.eks_cluster_name}") = "shared"
    "kubernetes.io/role/elb" = 1
  }
}