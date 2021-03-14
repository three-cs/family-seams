

resource "kubectl_manifest" "ingress_controller_crds" {
  yaml_body = data.http.ingress_controller_crds.body
  wait      = true
}

# https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/
# https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller
resource "helm_release" "ingress_controller" {
  depends_on = [kubectl_manifest.ingress_controller_crds]
  name       = "ingress-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.1.2"
  namespace  = "kube-system"
  wait       = false

  dynamic "set" {
    for_each = merge({
      "clusterName" = local.aws_region.eks.name
      },
      { for tag, value in local.default_tags : "defaultTags.${tag}" => value }
    )
    content {
      name  = set.key
      value = set.value
      type  = format("%s", set.value) == set.value ? "string" : "auto"
    }
  }
}