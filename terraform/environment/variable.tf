variable "target_regions" {
  type        = set(string)
  default     = ["us-west-2"]
  description = "AWS Regions to deploy into."
}
