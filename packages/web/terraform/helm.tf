
resource "helm_release" "web" {
  depends_on = [ module.aws ]
  name       = local.application
  # documentation : https://github.com/bitnami/charts/tree/master/bitnami/node
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "node"
  version    = "15.0.0"
  namespace = local.web.namespace
  create_namespace = true
  wait = true
  timeout = 600

  values = [file("${path.module}/helm/values.yaml")]

  set {
    name  = "image.registry"
    value = local.web.image.domain
    type  = "string"
  }

  set {
    name  = "image.repository"
    value = local.web.image.name
    type  = "string"
  }

  set {
    name  = "image.tag"
    value = local.web.version
    type  = "string"
  }

  set {
    name  = "image.pullPolicy"
    value = "Always"
    type  = "string"
  }

  set {
    name = "replicaCount"
    value = local.web.replicas
    type = "auto"
  }

  set {
    name = "applicationPort"
    value = local.web.http_port
    type = "auto"
  }

  set {
    name = "customLivenessProbe.httpGet.port"
    value = local.web.probe_port
    type = "auto"
  }

  set {
    name = "customReadinessProbe.httpGet.port"
    value = local.web.probe_port
    type = "auto"
  }

  set {
    name = "extraEnvVars[0].name"
    value = "SERVER_PORT"
    type = "string"
  }
  set {
    name = "extraEnvVars[0].value"
    value = local.web.http_port
    type = "string"
  }

  set {
    name = "extraEnvVars[1].name"
    value = "PROBE_PORT"
    type = "string"
  }

  set {
    name = "extraEnvVars[1].value"
    value = local.web.probe_port
    type = "string"
  }

  set {
    name = "service.type"
    value = "LoadBalancer"
    type = "string"
  }

  set {
    name = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb-ip"
    type = "string"
  }

  set {
    name = "ingress.enabled"
    value = true
    type = "auto"
  }

  set {
    name  = "mongodb.enabled"
    value = false
    type  = "auto"
  }
}

data "kubernetes_service" "web" {
  depends_on = [ helm_release.web ]
  metadata {
    name = "web-node"
    namespace = local.web.namespace
  }
}

resource "aws_route53_record" "web" {
  zone_id = local.aws.top_level_domain.hosted_zone_id
  name    = "web.${local.aws.top_level_domain.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.web.load_balancer_ingress[0].hostname]
}