resource "aws_s3_bucket" "terraform_bucket" {
  bucket        = "${local.organization}-terraform-bucket"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = merge(local.default_tags, {
    Name = "${local.organization}-terraform-bucket"
  })
}