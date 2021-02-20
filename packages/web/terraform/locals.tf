locals {
  environment  = terraform.workspace
  organization = data.terraform_remote_state.global.outputs.organization
  application  = var.application
  version      = var.image_version
  default_tags = {
    organization = local.organization
    environment  = local.environment
    purpose      = "application"
    application  = local.application
    version      = local.version
  }

  aws = data.terraform_remote_state.environment.outputs.aws

  web = {
    "version"    = local.version
    "image"      = data.terraform_remote_state.global.outputs.ecrs["${local.organization}/web"]
    "http_port"  = 3000
    "probe_port" = 3000
    "replicas"   = 3
    "namespace"  = "web"
    "subdomain"  = "web"
  }

  top_level_domain = data.terraform_remote_state.environment.outputs.aws.top_level_domain
  target_regions = (length(var.target_regions) == 0
    ? keys(data.terraform_remote_state.environment.outputs.aws.regions)
  : var.target_regions)
}