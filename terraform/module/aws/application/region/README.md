# AWS - Application - Region

Module responsible for creating all application resources in an AWS Region.

## Usage
This is designed to be a re-usable module.

```hcl
module "us_east_1" {
  source = "this module"

  # Globally required information
  environment      = terraform.workspace
  organization     = "your organization name"
  default_tags     = {}

  # Environment Region specific information
  # All the outputs from envronment.region
  aws_region = 

  # Application specific information
  namespaces = [] # Namespaces to create and associate with fargate profile

  # Aliased providers are required if multiple regions are going to be used.
  providers = {
    aws        = aws.us_east_1
    kubernetes = kubernetes.us_east_1
  }
}
```

