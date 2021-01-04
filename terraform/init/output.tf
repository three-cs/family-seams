output "domain_is_aws_registered" {
  value       = tobool(data.external.registered_domain.result.ready)
  description = "Test if domain is an AWS Registered Domain."
}

output "domain" {
  value       = var.domain_name
  description = "Domain name for the application."
}

output "hosted_zone_id" {
  value       = data.external.registered_domain.result.hosted_zone
  description = "Domain name for the application."
}