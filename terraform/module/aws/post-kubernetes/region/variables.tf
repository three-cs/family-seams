
variable "environment" {
  type        = string
  description = "Name of the environment."
}

variable "organization" {
  type        = string
  description = "Organization identifier for ownership."
}

variable "ogranization_email" {
  type = string
  description = "Default email address"
}

variable "default_tags" {
  type        = map(string)
  description = "Map of tags to apply to all AWS resources."
}

variable "aws_region" {
  type = object({
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
  })
  description = "AWS Information from environment."
}

variable "top_level_domain" {
  type = object({
    domain         = string,
    hosted_zone_id = string
  })
  description = "Top level domain information"
}

variable "cluster_issuer_access_key" {
  type = map(string)
  description = "Access Key Credentials for the access_key."
}