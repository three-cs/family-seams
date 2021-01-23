provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
}
provider "kubernetes" {
  alias = "us_east_1"
  config_context = "arn:aws:eks:us-east-1:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
}

provider "aws" {
  alias = "us_east_2"
  region = "us-east-2"
}
provider "kubernetes" {
  alias = "us_east_2"
  config_context = "arn:aws:eks:us-east-2:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
}

provider "aws" {
  alias = "us_west_1"
  region = "us-west-1"
}
provider "kubernetes" {
  alias = "us_west_1"
  config_context = "arn:aws:eks:us-west-1:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
}

provider "aws" {
  alias = "us_west_2"
  region = "us-west-2"
}
provider "kubernetes" {
  alias = "us_west_2"
  config_context = "arn:aws:eks:us-west-2:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
}

# TODO : Add providers for additional regions
# "eu-north-1"
# "ap-south-1"
# "eu-west-3"
# "eu-west-2"
# "eu-west-1"
# "ap-northeast-2"
# "ap-northeast-1"
# "sa-east-1"
# "ca-central-1"
# "ap-southeast-1"
# "ap-southeast-2"
# "eu-central-1"