# Create dedicated workload identity for Key Vault access
resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "identity-keyvault-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

# Grant Key Vault access to workload identity using RBAC
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

