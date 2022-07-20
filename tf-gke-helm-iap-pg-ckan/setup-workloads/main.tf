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

  # @TODO: Enable this after current issue is fixed
  #   values = [
  #     "${file("ckan_values.yaml")}"
  #   ]

}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    labels = {
      app = "ckan-ingress"
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
