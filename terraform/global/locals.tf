locals {
  organization = data.terraform_remote_state.init.outputs.organization
  default_tags = {
    organization = local.organization
    purpose      = "global"
  }

  repositories = var.repositories

  ecr_domain = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"

  top_level_domain = data.terraform_remote_state.init.outputs.top_level_domain
  ecrs = { for repo, ecr in aws_ecr_repository.repository :
    ecr.name => {
      "domain" = local.ecr_domain
      "name"   = ecr.name
      "url"    = ecr.repository_url
    }
  }
}