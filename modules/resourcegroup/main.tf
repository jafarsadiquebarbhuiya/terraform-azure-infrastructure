resource "azurerm_resource_group" "dev_rg" {
  count    = var.rg_count
  name     = "rg-${var.project_name}-${var.project_environment}-${count.index}"
  location = var.azure_resource_location
  tags     = var.tags
}
