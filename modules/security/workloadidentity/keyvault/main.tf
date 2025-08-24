data "azurerm_client_config" "current" {}

# Create dedicated workload identity for Key Vault access
resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "identity-keyvault-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

# Grant Key Vault access to workload identity using RBAC
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

# Create federated identity credential for AKS workload identity
resource "azurerm_federated_identity_credential" "workload_identity" {
  name                = "keyvault-workload-identity"
  resource_group_name = var.az_resource_group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload_identity.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"
}