# this file depends on contents of main.tf

resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_container_cluster.primary]
  create_duration = "30s"
}

module "gke_auth" {
  depends_on           = [time_sleep.wait_30_seconds]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id           = "streetz"
  cluster_name         = "dev-workloads-cluster"
  location             = "us-central1"
  use_private_endpoint = false
}
