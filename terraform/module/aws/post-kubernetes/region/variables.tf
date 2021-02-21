
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
