variable "repositories" {
  type = set(string)
  default = ["testing/repo"]
  description = "Names of container image repositories."
}