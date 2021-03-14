
variable "environment" {
  type        = string
  description = "Name of the environment.  If 'production', then a new subdomain will not be created."
}

variable "organization" {
  type        = string
  description = "Organization identifier for ownership."
}

variable "ogranization_email" {
  type        = string
  description = "Default email address"
}

variable "default_tags" {
  type        = map(string)
  description = "Map of tags to apply to all AWS resources."
}

variable "target_regions" {
  type        = set(string)
  description = "Regions to deploy into."
}

variable "aws" {
  type = object({
    regions = map(object({
      region = string,
      eks = object({
        name     = string,
        arn      = string,
        endpoint = string
      }),
      vpc = object({
        id              = string,
        cidr            = string,
        private_subnets = set(string),
        public_subnets  = set(string)
      })
    })),
    top_level_domain = object({
      domain         = string,
      hosted_zone_id = string
    })
  })
  description = "AWS Information from environment."
}