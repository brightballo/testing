provider "google" {
  project = "dev-workloads"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "dev-workloads-terraform-state"
    prefix  = "infra"
  }
}

variable "pg_instance_name" {
  type    = string
  default = "dev-workloads-db"
}

variable "root_password" {
  type    = string
  default = "complexpassword"
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

resource "google_compute_address" "static" {
  name = "ipv4-address"
}