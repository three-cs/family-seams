
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



variable "cidr" {
  type        = string
  description = "CIDR to for all AWS resource within Region"
}

variable "availability_zone_count" {
  type        = number
  default     = 3
  description = "Number of availability zones to target for this region."
}


variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster unique to the region."
}