
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
