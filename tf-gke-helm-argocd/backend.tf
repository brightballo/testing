terraform {
  backend "gcs" {
    bucket = "dev-workloads-terraform-state"
    prefix  = "gke-helm-argocd"
  }
}
