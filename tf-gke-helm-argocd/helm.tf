provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

#ArgoCD Helm Installation
resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace        = "argocd"
  create_namespace = true
}
