variable "pg_instance_name" {
  type    = string
  default = "dev-workloads"
}

variable "root_user" {
  type    = string
  default = "postgres"
}

variable "root_password" {
  type    = string
  default = "complexpassword"
}

variable "database_name" {
  type    = string
  default = "postgres"
}

