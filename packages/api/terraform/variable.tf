
variable "application" {
  type = string
  description = "Name of the application."
}

variable "version" {
  type = string
  description = "Application version.  MUST be same as tag for container."
}

variable "target_regions" {
  type = set(string)
  default = ["us-west-2"]
  description = "AWS Regions to deploy into. Target all Regions if empty."
}