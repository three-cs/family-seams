locals {
  environment = terraform.workspace
  organization = data.terraform_remote_state.global.outputs.organization
  application = var.application
  version = var.version
  default_tags = {
    organization = local.organization
    environment = local.environment
    purpose = "application"
    application = local.application
    version = local.version
  }

  api = {
    "version" = local.version
    "image" = data.terraform_remote_state.global.outputs["${local.organization}/api"]
    "http_port" = 3000
    "probe_port" = 3000
    "replicas" = 3
  }

  top_level_domain = data.terraform_remote_state.environment.outputs.aws.top_level_domain
  target_regions = (length(var.target_regions) == 0 
    ? keys(data.terraform_remote_state.environment.outputs.aws.regions)
    : var.target_regions)
}