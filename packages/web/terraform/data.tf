


data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "family-seams-terraform-bucket"
    key    = "global/terraform.tfstate"
  }
}

data "terraform_remote_state" "environment" {
  backend   = "s3"
  workspace = local.environment

  config = {
    bucket = "family-seams-terraform-bucket"
    key    = "environment/terraform.tfstate"
  }
}

data "terraform_remote_state" "post_kubernetes" {
  backend   = "s3"
  workspace = local.environment

  config = {
    bucket = "family-seams-terraform-bucket"
    key    = "post-kubernetes/terraform.tfstate"
  }
}
