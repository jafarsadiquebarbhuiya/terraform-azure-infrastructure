output "resource_group_names" {
  description = "List of all resource group names"
  value       = azurerm_resource_group.resourcegroup[*].name
}

output "resource_group_ids" {
  description = "List of all resource group IDs"
  value       = azurerm_resource_group.resourcegroup[*].id
}

output "primary_resource_group_name" {
  description = "Primary resource group name (first one)"
  value       = azurerm_resource_group.resourcegroup[0].name
}

output "primary_resource_group_id" {
  description = "Primary resource group ID (first one)"
  value       = azurerm_resource_group.resourcegroup[0].id
}
