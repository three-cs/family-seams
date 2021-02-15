variable "domain_name" {
  type        = string
  default     = "family-seams.com"
  description = "Domain name for the application."
}

variable "organization" {
  type        = string
  default     = "family-seams"
  description = "Identifier for the organization."
}

variable "domain_contact" {
  type = map(string)
  description = "Contact information for the domain registration."
  sensitive = true
}