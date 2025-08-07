data "azurerm_client_config" "current" {}
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.common_config.project_name}${var.common_config.project_environment}"
  resource_group_name = var.az_resource_group
  location            = var.common_config.az_resource_location
  sku                 = "Standard"
  admin_enabled       = false

  # Enable system-assigned managed identity for ACR operations
  identity {
    type = "SystemAssigned"
  }
}
# Network access configuration - VNet integration only
#   network_rule_set {
#     default_action = "Deny"

#     # Allow access from AKS subnet
#     virtual_network {
#       action    = "Allow"
#       subnet_id = var.aks_subnet_id
#     }
#   }

#   tags = var.common_config.tags
# }

# Role assignment for AKS kubelet identity to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_kubelet_identity_object_id
}

# Role assignment for AKS managed identity to push images during CI/CD
resource "azurerm_role_assignment" "aks_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = var.aks_user_assigned_identity_principal_id
}

# Create user-assigned managed identity for microservice deployments
resource "azurerm_user_assigned_identity" "microservice_identity" {
  name                = "identity-microservices-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

# Grant microservice identity ACR pull access
resource "azurerm_role_assignment" "microservice_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.microservice_identity.principal_id
}

# Grant microservice identity Key Vault secrets access
resource "azurerm_key_vault_access_policy" "microservice_keyvault_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.microservice_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}