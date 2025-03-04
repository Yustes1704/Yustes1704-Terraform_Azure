provider "azurerm" {
  features {}
  subscription_id = "3fd7ec5f-004a-4605-b7d3-96f4c305b45d"
}

resource "azurerm_resource_group" "lab_plataformas_rg" {
  name     = "lab_plataformas_rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "yustes-aks1" {
  name                = "yustes-aks1"
  location            = azurerm_resource_group.lab_plataformas_rg.location
  resource_group_name = azurerm_resource_group.lab_plataformas_rg.name
  dns_prefix          = "yustes1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production-lab_plataformas_rg"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.yustes-aks1.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.yustes-aks1.kube_config_raw

  sensitive = true
}