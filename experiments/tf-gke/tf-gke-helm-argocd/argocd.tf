# terraform {
#   required_providers {
#     argocd = {
#       source = "oboukili/argocd"
#       version = "3.2.0"
#     }
#   }
# }

# provider "argocd" {
#   server_addr = "35.238.213.243:80"
#   username  = "admin"
#   password = "22R4GUIoL79zeEYc"
# }

# resource "argocd_application" "root" {
#   metadata {
#     name      = "root"
#     namespace = "default"
#     labels = {
#       test = "true"
#     }
#   }

#   spec {
#     project = "default"

#     source {
#       repo_url        = "https://github.com/Timtech4u/devops-playground.git"
#       path            = "ArgoCD-Apps"
#       target_revision = "HEAD"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "argocd"
#     }

#     sync_policy {
#       automated = {
#         prune       = true
#         self_heal   = true
#         allow_empty = true
#       }
#       # Only available from ArgoCD 1.5.0 onwards
#       sync_options = ["Validate=false"]
#       retry {
#         limit   = "5"
#         backoff = {
#           duration     = "30s"
#           max_duration = "2m"
#           factor       = "2"
#         }
#       }
#     }

#     # ignore_difference {
#     #   group         = "apps"
#     #   kind          = "Application"
#     # #   json_pointers = ["/spec/replicas"]
#     # }

#     # ignore_difference {
#     #   group         = "apps"
#     #   kind          = "StatefulSet"
#     #   name          = "someStatefulSet"
#     #   json_pointers = [
#     #     "/spec/replicas",
#     #     "/spec/template/spec/metadata/labels/bar",
#     #   ]
#     #   # Only available from ArgoCD 2.1.0 onwards
#     #   jq_path_expressions = [
#     #     ".spec.replicas",
#     #     ".spec.template.spec.metadata.labels.bar",
#     #   ]
#     # }
#   }
# }