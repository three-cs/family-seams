resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.2.0"
  namespace  = "kube-system"
  wait       = true
  timeout = 600

  set {
    name = "installCRDs"
    value = true
    type = "auto"
  }
  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt"
    type  = "string"
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
    type  = "string"
  }
  set {
    name  = "ingressShim.defaultIssuerGroup"
    value = "cert-manager.io"
    type  = "string"
  }
  set {
    name  = "ingressShim.defaultACMEChallengeType"
    value = "dns01"
    type  = "string"
  }
  set {
    name  = "ingressShim.defaultACMEDNS01ChallengeProvider"
    value = "route53"
    type  = "string"
  }
}

resource "kubectl_manifest" "wildcard_certificate" {
  depends_on = [helm_release.cert_manager]
  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Certificate"
    "metadata" = {
      "name" = "wildcard-certificate"
      "namespace" = "kube-system"
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
          "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
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