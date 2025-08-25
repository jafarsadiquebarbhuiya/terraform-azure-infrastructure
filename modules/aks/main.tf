resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "identity-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.common_config.project_name}-${var.common_config.project_environment}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  dns_prefix          = "aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  kubernetes_version  = var.kubernetes_version


  default_node_pool {
    name                        = "system"
    enable_auto_scaling         = true
    min_count                   = 1
    max_count                   = 2
    vm_size                     = "Standard_B2s"
    max_pods                    = 50 # INCREASED from 30 to 50
    vnet_subnet_id              = var.subnet_id
    temporary_name_for_rotation = "sytemp001"
  }
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  network_profile {
    network_plugin    = "azure"
    service_cidr      = "10.2.0.0/24"
    dns_service_ip    = "10.2.0.10"
    load_balancer_sku = "basic"
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  tags = var.common_config.tags

}

resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}