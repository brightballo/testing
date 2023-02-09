#ArgoCD Helm Installation
resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  # version = "4.9.12"
  version = "5.20.3"
  chart      = "argo-cd"

  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "global.image.tag"
    value = "v2.6.1"
  }
}
