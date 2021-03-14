output "region" {
  value       = local.region
  description = "AWS region name."
}

output "wildcard_certificate" {
  value = aws_acm_certificate.wildcard_certificate.arn
  description = "ARN for the wildcard certificate."
}