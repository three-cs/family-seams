

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
      "image.registry"                    = local.api.image.domain
      "image.repository"                  = local.api.image.name
      "image.tag"                         = local.api.version
      "image.pullPolicy"                  = "Always"
      "replicaCount"                      = local.api.replicas
      "applicationPort"                   = local.api.http_port
      "customLivenessProbe.httpGet.port"  = local.api.probe_port
      "customReadinessProbe.httpGet.port" = local.api.probe_port
      "extraEnvVars[0].name"              = "SERVER_PORT"
      "extraEnvVars[0].value"             = format("%s", local.api.http_port)
      "extraEnvVars[1].name"              = "PROBE_PORT"
      "extraEnvVars[1].value"             = format("%s", local.api.probe_port)
      "service.type"                      = "NodePort"
      # "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type" = "nlb-ip"
      "ingress.enabled" = false
      # "ingress.path" = "/*"
      # "ingress.hostname" = "api.${local.top_level_domain.domain}"
      # "ingress.extraTls[0].hosts[0]" = "api.${local.top_level_domain.domain}"
      # "ingress.extraTls[0].secretName" = "wildcard-certificate"
      # "ingress.annotations.kubernetes\\.io/ingress\\.class" = "alb"
      # "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme" = "internet-facing"
      # "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type" = "ip"
      # "ingress.annotations.cert-manager\\.io/cluster-issuer" = "letsencrypt"
      # "ingress.certManager" = true
      "mongodb.enabled" = false
    }
    content {
      name  = set.key
      value = set.value
      type  = format("%s", set.value) == set.value ? "string" : "auto"
    }
  }
}

resource "kubernetes_ingress" "api" {
  depends_on = [helm_release.api]

  wait_for_load_balancer = true

  // networking.k8s.io/v1
  metadata {
    name      = "${helm_release.api.metadata[0].name}-node"
    namespace = helm_release.api.metadata[0].namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/api/hello-world"
      "alb.ingress.kubernetes.io/certificate-arn"  = data.terraform_remote_state.post_kubernetes.outputs.result.regions["us-west-2"].wildcard_certificate
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        { "HTTP" = 80 },
        { "HTTPS" = 443 }
      ])
      "alb.ingress.kubernetes.io/tags" = join(",", [for name, value in local.default_tags : "${name}=${value}"])
      "kubernetes.io/ingress.class"    = "alb"
    }
  }

  spec {
    backend {
      service_name = "api-node"
      service_port = "http"
    }

    rule {
      host = "api.${local.top_level_domain.domain}"
      http {
        path {
          backend {
            service_name = "api-node"
            service_port = "http"
          }

          path = "/*"
        }
      }
    }

    tls {
      hosts       = ["api.${local.top_level_domain.domain}"]
      secret_name = "wildcard-certificate"
    }
  }
}
