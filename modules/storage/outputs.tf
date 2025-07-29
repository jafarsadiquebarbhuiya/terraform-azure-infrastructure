output "storage_account_names" {
  description = "List of all storage account names"
  value       = azurerm_storage_account.storage_account[*].name
}

output "storage_account_ids" {
  description = "List of all storage account IDs"
  value       = azurerm_storage_account.storage_account[*].id
}

output "primary_storage_account_name" {
  description = "Primary storage account name"
  value       = azurerm_storage_account.storage_account[0].name
}