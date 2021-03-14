resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.2.0"
  namespace  = "kube-system"
  wait       = true
  timeout = 600

  dynamic "set" {
    for_each = {
      "installCRDs" = true
      "ingressShim.defaultIssuerName" = "letsencrypt"
      "ingressShim.defaultIssuerKind" = "ClusterIssuer"
      "ingressShim.defaultIssuerGroup" = "cert-manager.io"
      "ingressShim.defaultACMEChallengeType" = "dns01"
      "ingressShim.defaultACMEDNS01ChallengeProvider" = "route53"
    }
    content {
      name  = set.key
      value = set.value
      type  = format("%s", set.value) == set.value ? "string" : "auto"
    }
  }
}

resource "helm_release" "reflector" {
  name       = "reflector-controller"
  repository = "https://emberstack.github.io/helm-charts"
  chart      = "reflector"
  version    = "5.4.17"
  namespace  = "kube-system"
  wait       = true
  timeout = 600
}

resource "kubernetes_secret" "cluster_issuer" {
  metadata {
    name = "cluster-issuer"
    namespace = "kube-system"
  }

  data = {
    AWS_SECRET_ACCESS_KEY = local.cluster_issuer_access_key.secret
  }

  type = "Opaque"
}

resource "kubectl_manifest" "cluster_issuer" {
  depends_on = [helm_release.cert_manager, kubernetes_secret.cluster_issuer]
  yaml_body = yamlencode({
      "apiVersion" = "cert-manager.io/v1"
      "kind" = "ClusterIssuer"
      "metadata" = {
        "name" = "letsencrypt"
        "namespace" = "kube-system"
      }
      "spec" = {
        "acme" = {
          "server" = "https://acme-v02.api.letsencrypt.org/directory"
          "email" = local.ogranization_email
          "privateKeySecretRef" = {
            "name" = "clusterissuer"
          }
          "solvers" = [
            {
              "selector" = {
                "dnsZones" = [
                  local.top_level_domain.domain
                ]
              }
              "dns01" = {
                "route53" = {
                  "region" = "us-east-1"
                  "hostedZoneID" = local.top_level_domain.hosted_zone_id
                  "accessKeyID" = local.cluster_issuer_access_key.id
                  "secretAccessKeySecretRef" = {
                    "name" = "cluster-issuer"
                    "namespace" = "kube-system"
                    "key" = "AWS_SECRET_ACCESS_KEY"
                  }   
                }
              }
            }
          ]
        }
      }
    })
  wait      = true
}

resource "kubectl_manifest" "wildcard_certificate" {
  depends_on = [helm_release.reflector, kubectl_manifest.cluster_issuer]
  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Certificate"
    "metadata" = {
      "name" = "wildcard-certificate"
      "namespace" = "kube-system"
      "annotations" = {
        "reflector.v1.k8s.emberstack.com/secret-reflection-allowed" = "true"
      }
    }
    "spec" = {
      "secretName" = "wildcard-certificate"
      "issuerRef" = {
        "name" = "letsencrypt"
        "kind" = "ClusterIssuer"
      }
      "commonName" = local.top_level_domain.domain
      "dnsNames" = [
        local.top_level_domain.domain,
        "*.${local.top_level_domain.domain}"
      ]
      "acme" = {
        "config" = [
          {
            "dns01" = {
              "provider" = "acmedns"
            }
            "domains" = [
              local.top_level_domain.domain,
              "*.${local.top_level_domain.domain}"
            ]
          }
        ]
      }
    }
  })
  wait      = true
}

resource "aws_acm_certificate" "wildcard_certificate" {
  private_key = data.kubernetes_secret.wildcard_certificate.data["tls.key"]
  certificate_body = local.certs[0]
  certificate_chain = data.kubernetes_secret.wildcard_certificate.data["tls.crt"]

  tags = merge({
    "Name"= "wildcard-certifiate"
  }, local.default_tags)

  lifecycle {
    create_before_destroy = true
  }
}