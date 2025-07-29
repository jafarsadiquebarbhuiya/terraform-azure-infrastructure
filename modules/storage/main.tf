resource "azurerm_storage_account" "storage_account" {
  count                    = var.storage_config.storage_count
  name                     = "st-${var.common_config.project_name}-${var.common_config.project_environment}-${count.index}"
  resource_group_name      = var.az_resource_group
  location                 = var.common_config.az_resource_location
  account_tier             = var.storage_config.storage_account_tier
  account_replication_type = var.storage_config.storage_account_replication_type

  tags = var.common_config.tags
}