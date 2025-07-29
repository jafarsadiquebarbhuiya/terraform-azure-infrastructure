resource "azurerm_resource_group" "resourcegroup" {
  count    = var.rg_config.rg_count
  name     = "rg-${var.common_config.project_name}-${var.common_config.project_environment}-${count.index}"
  location = var.common_config.az_resource_location
  tags     = var.common_config.tags
}
