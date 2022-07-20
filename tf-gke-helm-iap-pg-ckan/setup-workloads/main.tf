provider "google" {
  project = "dev-workloads"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "dev-workloads-terraform-state"
    prefix = "workloads"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm Installation
resource "helm_release" "ckan" {
  name = "ckan-app"

  repository = "https://keitaro-charts.storage.googleapis.com"
  chart      = "ckan"

  namespace        = "ckan"
  create_namespace = true

  set {
    name  = "MasterDBName"
    value = var.database_name
  }

  set {
    name  = "DBHost"
    value = var.database_ip
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

}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    labels = {
      app = "ckan-app"
    }
    name      = "ckan-ingress"
    annotations = {
      "kubernetes.io/ingress.class" : "gce"
      "networking.gke.io/managed-certificates" : "managed-cert"
      "kubernetes.io/ingress.global-static-ip-name" : "ipv4-address"
    }
  }

  spec {
    rule {
      host = "ckan.timtech4u.dev"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "ckan-ingress"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
