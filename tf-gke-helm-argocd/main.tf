provider "google" {
  project = "dev-workloads"
  region  = "us-central1"
}

# Cluster
resource "google_container_cluster" "primary" {
  name     = "dev-workloads-cluster"
  location = "us-central1"
  ip_allocation_policy { # https://github.com/hashicorp/terraform-provider-google/issues/10782
  }
  enable_autopilot = true
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}