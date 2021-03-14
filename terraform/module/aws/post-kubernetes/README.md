# AWS - Post Kubernetes - Region Selector

Module responsible for creating all environment after an 
EKS cluster has been created.

This selector will delegate region specific resource
creation to the [region module](./region).

## Usage
This is designed to be a re-usable module.

```hcl
module "region_selector" {
  source = "this module"

  # Globally required information
  environment      = terraform.workspace
  organization     = "your organization name"
  default_tags     = {}
  top_level_domain = "your top level domain name for environment"

  # Environment specific information
  target_regions = [ "us-west-2" ] # MUST contain mapping in the provider.tf and regions.tf file.
  base_cidr      = "10.0.0.0/16" # VPC cidr range to us accross all regions and environments
}
```

