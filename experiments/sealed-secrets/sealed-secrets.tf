provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Deploy Bitnami Sealed Secrets
resource "helm_release" "k8s_misc_sealed_secrets" {
  name    = "sealed-secrets"
  version = "1.16.1"

  namespace = "kube-systemz"
  create_namespace = true

  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"

  set {
    name  = "commandArgs[0]"
    value = "--update-status"
  }
  set {
    name  = "image.repository"
    value = "bitnami/sealed-secrets-controller"
  }
  set {
    name  = "image.tag"
    value = "v0.18.0"
  }
}
