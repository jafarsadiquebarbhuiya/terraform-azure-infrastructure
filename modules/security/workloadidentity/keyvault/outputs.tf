output "workload_identity_client_id" {
  value = azurerm_user_assigned_identity.workload_identity.client_id
}

output "aks_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}