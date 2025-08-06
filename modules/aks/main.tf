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
  name                      = "aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  location                  = var.common_config.az_resource_location
  resource_group_name       = var.az_resource_group
  dns_prefix                = "aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  kubernetes_version        = var.kubernetes_version
  automatic_channel_upgrade = "patch"
  sku_tier                  = "Standard"

  default_node_pool {
    name = "system"
    #node_count          = var.system_node_count
    vm_size             = "Standard_D2s_v3"
    type                = "VirtualMachineScaleSets"
    zones               = ["2"]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3 # Reduced to stay within quota
    max_pods            = 30
    vnet_subnet_id      = var.subnet_id

    upgrade_settings {
      max_surge = "10%"
    }

    tags = var.common_config.tags
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = "10.2.0.0/24"
    dns_service_ip    = "10.2.0.10"
  }

  azure_policy_enabled              = true
  http_application_routing_enabled  = false
  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  workload_autoscaler_profile {
    keda_enabled = true
  }

  tags = var.common_config.tags
}

# User node pool removed due to vCPU quota limits
# The system node pool can handle both system and user workloads

resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
