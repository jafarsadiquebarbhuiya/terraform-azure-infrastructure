# modules/acr/outputs.tf

output "acr_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "The name of the Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_system_assigned_identity" {
  description = "System-assigned managed identity of the Container Registry"
  value = {
    principal_id = azurerm_container_registry.acr.identity[0].principal_id
    tenant_id    = azurerm_container_registry.acr.identity[0].tenant_id
  }
}

output "microservice_identity_id" {
  description = "The ID of the microservice managed identity"
  value       = azurerm_user_assigned_identity.microservice_identity.id
}

output "microservice_identity_principal_id" {
  description = "The principal ID of the microservice managed identity"
  value       = azurerm_user_assigned_identity.microservice_identity.principal_id
}

output "microservice_identity_client_id" {
  description = "The client ID of the microservice managed identity"
  value       = azurerm_user_assigned_identity.microservice_identity.client_id
}