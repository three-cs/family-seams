
variable "repositories" {
  type = map(string)
  default = {
    "api" = "api",
    "web" = "web"
  }
  description = "Map of repository names to the associated application."
}