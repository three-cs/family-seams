data "aws_region" "current" {}

data "http" "ingress_controller_crds" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/v0.0.45/stable/aws-load-balancer-controller/crds/crds.yaml"
}

resource "time_sleep" "wildcard_certificate" {
  depends_on = [ kubectl_manifest.wildcard_certificate ]
  create_duration = "5m"
}

data "kubernetes_secret" "wildcard_certificate" {
  depends_on = [ time_sleep.wildcard_certificate ]
  metadata {
    name = "wildcard-certificate"
    namespace = "kube-system"
  }
}
