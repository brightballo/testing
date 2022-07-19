provider "google" {
  project = "dev-workloads"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "dev-workloads-terraform-state"
    prefix  = "workloads"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Helm Installation
resource "helm_release" "ckan" {
  name = "ckan"

  repository = "https://keitaro-charts.storage.googleapis.com"
  chart      = "ckan"

  set {
    name  = "service.type"
    value = "LoadBalancer" # creates public IP address
  }

  set {
    name  = "MasterDBName"
    value = var.database_name
  }

  set {
    name  = "DBHost"
    value = google_sql_database_instance.main.public_ip_address
  }

  set {
    name  = "MasterDBUser"
    value = var.root_user
  }

  set {
    name  = "MasterDBPass"
    value = var.root_password
  }

  set {
    name  = "MasterDBPass"
    value = var.root_password
  }

# @TODO: Enable this after current issue is fixed
#   values = [
#     "${file("ckan_values.yaml")}"
#   ]

  depends_on = [
    google_sql_database_instance.main,
    google_container_cluster.primary
  ]
}

