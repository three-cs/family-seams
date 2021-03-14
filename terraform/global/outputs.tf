
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

output "ecr_credential_location" {
  value       = "https://${aws_s3_bucket_object.ci_ecr_user.bucket}.s3.amazonaws.com/${aws_s3_bucket_object.ci_ecr_user.key}"
  description = "Location of the ECR push credentials to use."
}

output "ogranization_email" {
  value       = "family.seams@gmail.com"
  description = "Default email address"
}