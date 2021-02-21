data "aws_region" "current" {}

data "http" "ingress_controller_crds" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/v0.0.45/stable/aws-load-balancer-controller/crds/crds.yaml"
}
