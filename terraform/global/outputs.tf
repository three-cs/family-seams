
output "organization" {
  value       = local.organization
  description = "Name of the organization to use."
}

output "top_level_domain" {
  value       = local.top_level_domain
  description = "Top Level Domain information."
}

output "ecrs" {
  value       = local.ecrs
  description = "Information about the created ECR repositories."
}