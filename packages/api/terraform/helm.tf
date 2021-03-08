
resource "helm_release" "api" {
  name = local.application
  # documentation : https://github.com/bitnami/charts/tree/master/bitnami/node
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "node"
  version          = "15.0.0"
  namespace        = local.api.namespace
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [file("${path.module}/helm/values.yaml")]

  dynamic "set" {
    for_each = {
      "image.registry" = local.api.image.domain
      "image.repository" = local.api.image.name
      "image.tag" = local.api.version
      "image.pullPolicy" = "Always"
      "replicaCount" = local.api.replicas
      "applicationPort" = local.api.http_port
      "customLivenessProbe.httpGet.port" = local.api.probe_port
      "customReadinessProbe.httpGet.port" = local.api.probe_port
      "extraEnvVars[0].name" = "SERVER_PORT"
      "extraEnvVars[0].value" = format("%s", local.api.http_port)
      "extraEnvVars[1].name" = "PROBE_PORT"
      "extraEnvVars[1].value" = format("%s", local.api.probe_port)
      "service.type" = "LoadBalancer"
      "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type" = "ip"
      "ingress.enabled" = true
      "ingress.hostname" = "api.${local.top_level_domain.domain}"
      # "ingress.certManager" = true
      # "ingress.tls" = true
      # "ingress.annotations.cert-manager\\.io/cluster-issuer" = "letsencrypt"
      "mongodb.enabled" = false
    }
    content {
      name  = set.key
      value = set.value
      type  = format("%s", set.value) == set.value ? "string" : "auto"
    }
  }
}
