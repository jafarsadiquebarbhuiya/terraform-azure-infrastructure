# ../../modules/security/workloadidentity/keyvault/outputs.tf

output "workload_identity_client_id" {
  description = "Client ID of the workload identity"
  value       = azurerm_user_assigned_identity.workload_identity.client_id
}

output "workload_identity_principal_id" {
  description = "Principal ID of the workload identity"
  value       = azurerm_user_assigned_identity.workload_identity.principal_id
}

output "workload_identity_id" {
  description = "ID of the workload identity"
  value       = azurerm_user_assigned_identity.workload_identity.id
}

output "tenant_id" {
  description = "Azure AD tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "federated_credential_name" {
  description = "Name of the federated identity credential"
  value       = azurerm_federated_identity_credential.workload_identity.name
}