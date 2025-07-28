output "resource_group_name_output" {
  description = "Resource group name"
  value       = azurerm_resource_group.dev_rg.name
}
output "resource_group_name_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.dev_rg.id
}
