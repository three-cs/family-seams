
resource "helm_release" "api" {
  depends_on = [module.aws]
  name       = local.application
  # documentation : https://github.com/bitnami/charts/tree/master/bitnami/node
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "node"
  version          = "15.0.0"
  namespace        = local.api.namespace
  create_namespace = true
  wait             = false

  values = [file("${path.module}/helm/values.yaml")]

  set {
    name  = "image.registry"
    value = local.api.image.domain
    type  = "string"
  }

  set {
    name  = "image.repository"
    value = local.api.image.name
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = local.api.version
    type  = "string"
  }

  set {
    name  = "image.pullPolicy"
    value = "Always"
    type  = "string"
  }

  set {
    name  = "replicaCount"
    value = local.api.replicas
    type  = "auto"
  }

  set {
    name  = "applicationPort"
    value = local.api.http_port
    type  = "auto"
  }

  set {
    name  = "customLivenessProbe.httpGet.port"
    value = local.api.probe_port
    type  = "auto"
  }

  set {
    name  = "customReadinessProbe.httpGet.port"
    value = local.api.probe_port
    type  = "auto"
  }

  set {
    name  = "extraEnvVars[0].name"
    value = "SERVER_PORT"
    type  = "string"
  }
  set {
    name  = "extraEnvVars[0].value"
    value = local.api.http_port
    type  = "string"
  }

  set {
    name  = "extraEnvVars[1].name"
    value = "PROBE_PORT"
    type  = "string"
  }

  set {
    name  = "extraEnvVars[1].value"
    value = local.api.probe_port
    type  = "string"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
    type  = "string"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb-ip"
    type  = "string"
  }

  set {
    name  = "ingress.enabled"
    value = true
    type  = "auto"
  }

  set {
    name  = "mongodb.enabled"
    value = false
    type  = "auto"
  }
}

data "kubernetes_service" "api" {
  depends_on = [helm_release.api]
  metadata {
    name      = "api-node"
    namespace = local.api.namespace
  }
}

resource "aws_route53_record" "api" {
  zone_id = local.aws.top_level_domain.hosted_zone_id
  name    = "api.${local.aws.top_level_domain.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.api.status[0].load_balancer[0].ingress[0].hostname]
}