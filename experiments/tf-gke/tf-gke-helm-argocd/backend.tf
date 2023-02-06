terraform {
  backend "gcs" {
    bucket = "streetz-terraform-state"
    prefix  = "gke-helm-argocd"
  }
}
