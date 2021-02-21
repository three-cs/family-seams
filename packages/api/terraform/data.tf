


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

data "kubernetes_service" "api" {
  metadata {
    name      = "${helm_release.api.metadata[0].name}-node"
    namespace = helm_release.api.metadata[0].namespace
  }
}
