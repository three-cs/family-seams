terraform {
  required_version = "~> 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }
  }
  backend "s3" {
    bucket = "family-seams-terraform-bucket"
    key    = "application/api/terraform.tfstate"
  }
}
