output "resource_group_name_output" {
  description = "Names of all created resource groups"
  value       = azurerm_resource_group.dev_rg[*].name
}

output "resource_group_name_id" {
  description = "IDs of all created resource groups"
  value       = azurerm_resource_group.dev_rg[*].id
}