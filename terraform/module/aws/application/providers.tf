provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
provider "kubernetes" {
  alias          = "us_east_1"
  config_context = try(local.aws.regions["us-east-1"].eks.arn, "not-set")
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}
provider "kubernetes" {
  alias          = "us_east_2"
  config_context = try(local.aws.regions["us-east-2"].eks.arn, "not-set")
}

provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
}
provider "kubernetes" {
  alias          = "us_west_1"
  config_context = try(local.aws.regions["us-west-1"].eks.arn, "not-set")
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}
provider "kubernetes" {
  alias          = "us_west_2"
  config_context = try(local.aws.regions["us-west-2"].eks.arn, "not-set")
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