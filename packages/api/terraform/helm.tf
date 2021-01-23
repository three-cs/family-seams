
resource "helm_release" "api" {
  name       = local.application
  # documentation : https://github.com/bitnami/charts/tree/master/bitnami/node
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "bitnami/node"
  version    = "15.0.0"

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
    name = "replicaCount"
    value = local.api.replicas
    type = "auto"
  }

  set {
    name = "applicationPort"
    value = local.api.http_port
    type = "auto"
  }

  set {
    name = "customLivenessProbe.httpGet.port"
    value = local.api.probe_port
    type = "auto"
  }

  set {
    name = "customReadinessProbe.httpGet.port"
    value = local.api.probe_port
    type = "auto"
  }

  set {
    name = "extraEnvVars[0].name"
    value = "SERVER_PORT"
    type = "string"
  }
  set {
    name = "extraEnvVars[0].value"
    value = local.api.http_port
    type = "auto"
  }

  set {
    name = "extraEnvVars[1].name"
    value = "PROBE_PORT"
    type = "string"
  }

  set {
    name = "extraEnvVars[1].value"
    value = local.api.probe_port
    type = "auto"
  }

  set {
    name = "service.type"
    value = "LoadBalancer"
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