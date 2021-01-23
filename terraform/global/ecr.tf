resource "aws_ecr_repository" "repository" {
  for_each = local.repositories

  name                 = "${local.organization}/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.default_tags, {
    Name = "repo/${local.organization}/${each.key}"
    application = each.value
  })
}

# TODO: Figure out how to restrict to ECR repos created via terraform
resource "aws_iam_user" "ci_ecr_user" {
  name = "${local.organization}-ci-ecr-user"
  force_destroy = true

  tags = local.default_tags
}

resource "aws_iam_user_policy_attachment" "ci_ecr_user" {
  user       = aws_iam_user.ci_ecr_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_access_key" "ci_ecr_user" {
  user = aws_iam_user.ci_ecr_user.name
}

locals {
  ci_ecr_user_credentials_json = jsonencode({
      "AWS_ACCESS_KEY_ID" = aws_iam_access_key.ci_ecr_user.id
      "AWS_SECRET_ACCESS_KEY" = aws_iam_access_key.ci_ecr_user.secret
      "user" = aws_iam_access_key.ci_ecr_user.user
    })
}

resource "aws_s3_bucket_object" "ci_ecr_user" {
  bucket = "family-seams-terraform-bucket"
  key    = "global/credentials/ci_ecr_user.json"
  content_type = "application/json"
  etag = md5(jsonencode(aws_iam_access_key.ci_ecr_user))
  content = jsonencode(aws_iam_access_key.ci_ecr_user)
}