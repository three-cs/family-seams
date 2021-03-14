



resource "aws_iam_user" "cluster_issuer" {
  name = "${local.organization}-${local.environment}-cluster_issuer"
  path = "/"

  tags = local.default_tags
}

resource "aws_iam_access_key" "cluster_issuer" {
  user = aws_iam_user.cluster_issuer.name
}

resource "aws_iam_policy" "cluster_issuer" {
  name        = "${local.organization}-${local.environment}-cluster-issuer"
  path        = "/"
  description = "Policy for Cluster Issuer to manage certificates."

  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect"   = "Allow"
        "Action"   = "route53:GetChange"
        "Resource" = "arn:aws:route53:::change/*"
      },
      {
        "Effect" = "Allow"
        "Action" = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        "Resource" = "arn:aws:route53:::hostedzone/*"
      },
      {
        "Effect"   = "Allow"
        "Action"   = "route53:ListHostedZonesByName"
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "cluster_issuer" {
  user       = aws_iam_user.cluster_issuer.name
  policy_arn = aws_iam_policy.cluster_issuer.arn
}