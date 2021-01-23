
variable "repositories" {
  type = map(string)
  default = {
    "api" = "api"
  }
  description = "Map of repository names to the associated application."
}