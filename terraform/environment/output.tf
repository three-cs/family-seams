
output "aws" {
  value = module.region_selector
  description = "Information about the AWS environment."
}

output "organization" {
  value       = local.organization
  description = "Name of the organization to use."
}

output "environment" {
  value       = local.environment
  description = "Name of the environment to use."
}