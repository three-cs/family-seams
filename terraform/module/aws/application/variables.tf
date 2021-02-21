
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

variable "application" {
  type        = string
  description = "Name of the application. Added to subdomain and namespaces."
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

variable "namespaces" {
  type        = set(string)
  default     = []
  description = "Namespaces to associate with an EKS Fargate Profile."
}

variable "subdomains" {
  type        = set(string)
  default     = []
  description = "Subdomains to create for the kubernetes services."
}

variable "subdomain_load_balancers" {
  type        = map(string)
  default     = {}
  description = "Map of subdomains to aws load balancer hostnames."
}