output "region" {
  value       = local.region
  description = "AWS region name."
}

output "vpc" {
  value       = local.vpc
  description = "VPC Information"
}

output "eks" {
  value       = local.eks
  description = "EKS Information"
}