provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "devops-playground" {
  name     = "devops-playground"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "dpregistryhs"
  resource_group_name = azurerm_resource_group.devops-playground.name
  location            = azurerm_resource_group.devops-playground.location
  sku                 = "Premium"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "devops-playground-cluster" {
  name                = "devops-playground-cluster"
  location            = azurerm_resource_group.devops-playground.location
  resource_group_name = azurerm_resource_group.devops-playground.name
  dns_prefix = "devops-playground-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_d2ads_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "devops-playground-assignment" {
  principal_id                     = azurerm_kubernetes_cluster.devops-playground-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.devops-playground-cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.devops-playground-cluster.kube_config_raw

  sensitive = true
}
