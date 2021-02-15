
variable "environment" {
  type        = string
  description = "Name of the environment.  If 'production', then a new subdomain will not be created."
}

variable "organization" {
  type        = string
  description = "Organization identifier for ownership."
}

variable "default_tags" {
  type        = map(string)
  description = "Map of tags to apply to all AWS resources."
}



variable "target_regions" {
  type        = set(string)
  description = "Regions to deploy into."
}

variable "base_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR to divide up amungst all AWS regions."
}


variable "top_level_domain" {
  type = object({
    domain         = string,
    hosted_zone_id = string
  })
  description = "Top Level Domain information."
}