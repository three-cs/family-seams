# AWS - Environment - Region

Module responsible for creating all environment resources in an AWS Region.

## Usage
This is designed to be a re-usable module.

```hcl
module "us_east_1" {
  source = "this module"

  # Globally required information
  environment  = local.environment
  organization = local.organization
  default_tags = local.default_tags

  # Environment Region specific information
  cidr         = 
  eks          = 

  # Aliased providers are required if multiple regions are going to be used.
  providers = {
    aws        = aws.us_east_1
    kubernetes = kubernetes.us_east_1
  }
}
```

