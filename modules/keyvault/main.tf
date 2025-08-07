data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                       = "kv-aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  location                   = var.common_config.az_resource_location
  resource_group_name        = var.az_resource_group
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    virtual_network_subnet_ids = [var.keyvault_subnet_id]
    ip_rules                   = ["106.215.140.107/32", "172.203.7.49/32"]
  }

  tags = var.common_config.tags
}

# Grant access to current user (for initial setup)
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover"
  ]
}

# Sample secrets for demonstration
resource "azurerm_key_vault_secret" "database_connection" {
  name         = "database-connection-string"
  value        = "Server=myserver;Database=mydb;User Id=myuser;Password=mypassword;"
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

resource "azurerm_key_vault_secret" "api_key" {
  name         = "external-api-key"
  value        = "your-secret-api-key-here"
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

resource "azurerm_key_vault_secret" "redis_password" {
  name         = "redis-password"
  value        = "your-redis-password-here"
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [azurerm_key_vault_access_policy.current_user]
}
