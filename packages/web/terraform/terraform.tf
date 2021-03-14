terraform {
  required_version = "~> 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }
  }
  backend "s3" {
    bucket = "family-seams-terraform-bucket"
    key    = "application/web/terraform.tfstate"
  }
}
