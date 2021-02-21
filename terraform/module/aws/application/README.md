# AWS - Application - Region Selector

Module responsible for creating all application resources.

This selector will delegate region specific resource
creation to the [region module](./region).

## Usage
This is designed to be a re-usable module.

```hcl
module "aws" {
  source = "this module"

  # Globally required information
  environment      = terraform.workspace
  organization     = "your organization name"
  default_tags     = {}

  # Environment specific information
  # MUST contain mapping in the provider.tf and regions.tf file.
  target_regions = [ "us-west-2" ]
  # All the outputs from envronment.region_selector
  aws = 

  # Application specific information
  application = "your application name"
  subdomains = {} # Ingress Subdomains to create for the application 
                  # mapped to load balancer domain names
  namespaces = [] # Namespaces to create and associate with fargate profile
}
```

