
resource "helm_release" "web" {
  name = local.application
  # documentation : https://github.com/bitnami/charts/tree/master/bitnami/node
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "node"
  version          = "15.0.0"
  namespace        = local.web.namespace
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [file("${path.module}/helm/values.yaml")]

  dynamic "set" {
    for_each = {
      "image.registry" = local.web.image.domain
      "image.repository" = local.web.image.name
      "image.tag" = local.web.version
      "image.pullPolicy" = "Always"
      "replicaCount" = local.web.replicas
      "applicationPort" = local.web.http_port
      "customLivenessProbe.httpGet.port" = local.web.probe_port
      "customReadinessProbe.httpGet.port" = local.web.probe_port
      "extraEnvVars[0].name" = "SERVER_PORT"
      "extraEnvVars[0].value" = format("%s", local.web.http_port)
      "extraEnvVars[1].name" = "PROBE_PORT"
      "extraEnvVars[1].value" = format("%s", local.web.probe_port)
      "service.type" = "LoadBalancer"
      "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type" = "nlb-ip"
      "ingress.enabled" = true
      "ingress.hostname" = "web.${local.top_level_domain.domain}"
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
