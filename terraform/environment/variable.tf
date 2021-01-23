variable "target_regions" {
  type = set(string)
  default = ["us-west-2", "us-east-2"]
  description = "AWS Regions to deploy into."
}
