
variable "environment" {
  type        = string
  description = "Name of the environment."
}

variable "organization" {
  type        = string
  description = "Organization identifier for ownership."
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