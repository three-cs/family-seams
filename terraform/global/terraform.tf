terraform {
  required_version = "~> 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24.1"
    }
  }
  backend "s3" {
    bucket = "family-seams-terraform-bucket"
    key    = "global/terraform.tfstate"
  }
}