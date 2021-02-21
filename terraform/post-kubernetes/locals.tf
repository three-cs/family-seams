locals {
  environment  = terraform.workspace
  organization = data.terraform_remote_state.global.outputs.organization
  default_tags = {
    organization = local.organization
    environment  = local.environment
    purpose      = "post-kubernetes"
  }
}