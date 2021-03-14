
resource "kubernetes_secret" "wildcard_certificate" {
  for_each = local.namespaces

  metadata {
    name      = "wildcard-certificate"
    namespace = each.key
    annotations = {
      "reflector.v1.k8s.emberstack.com/reflects" = "kube-system/wildcard-certificate"
    }
  }

  data = {
    "tls.crt" = ""
    "tls.key" = ""
  }

  type = "kubernetes.io/tls"

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["reflector.v1.k8s.emberstack.com/reflected-at"],
      metadata[0].annotations["reflector.v1.k8s.emberstack.com/reflected-version"],
      data
    ]
  }
}