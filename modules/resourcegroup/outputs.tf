output "resource_group_names" {
  description = "List of all resource group names"
  value       = azurerm_resource_group.dev_rg[*].name
}

output "resource_group_ids" {
  description = "List of all resource group IDs"
  value       = azurerm_resource_group.dev_rg[*].id
}

output "primary_resource_group_name" {
  description = "Primary resource group name (first one)"
  value       = azurerm_resource_group.dev_rg[0].name
}

output "primary_resource_group_id" {
  description = "Primary resource group ID (first one)"
  value       = azurerm_resource_group.dev_rg[0].id
}
