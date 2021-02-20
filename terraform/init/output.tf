# output "domain_is_aws_registered" {
#   value       = tobool(data.external.registered_domain.result.ready)
#   description = "Test if domain is an AWS Registered Domain."
# }

output "top_level_domain" {
  value       = local.top_level_domain
  description = "Top Level Domain information."
}

output "organization" {
  value       = local.organization
  description = "Name of the organization to use."
}