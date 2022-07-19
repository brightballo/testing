provider "google" {
  project = "dev-workloads"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "dev-workloads-terraform-state"
  }
}

# Database
resource "google_sql_database_instance" "main" {
  name             = var.pg_instance_name
  database_version = "POSTGRES_14"
  region           = "us-central1"

  root_password = var.root_password

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      authorized_networks {
        value = "0.0.0.0/0"
        name  = "internet"
      }
    }
  }
}

# Cluster
resource "google_container_cluster" "primary" {
  name     = "dev-workloads-cluster"
  location = "us-central1"
  ip_allocation_policy { # https://github.com/hashicorp/terraform-provider-google/issues/10782
  }
  enable_autopilot = true
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

  depends_on = [
    google_sql_database_instance.main
  ]
}

# deploy ingress controller
resource "helm_release" "ingress" {
  name       = "ingress"
  namespace = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = true
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

}

# @TODO: bump terraform
# resource "kubernetes_manifest" "clusterissuer_letsencrypt_prod" {
#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind" = "ClusterIssuer"
#     "metadata" = {
#       "name" = "letsencrypt-prod"
#     }
#     "spec" = {
#       "acme" = {
#         "email" = "timothyolaleke@gmail.com"
#         "privateKeySecretRef" = {
#           "name" = "letsencrypt-prod"
#         }
#         "server" = "https://acme-v02.api.letsencrypt.org/directory"
#         "solvers" = [
#           {
#             "http01" = {
#               "ingress" = {
#                 "class" = "nginx"
#               }
#             }
#           },
#         ]
#       }
#     }
#   }
# }
