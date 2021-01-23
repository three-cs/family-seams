

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "family-seams-terraform-bucket"
    key    = "global/terraform.tfstate"
  }
}