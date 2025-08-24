output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "kubelet_identity_client_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
}

output "cluster_identity_principal_id" {
  value = azurerm_user_assigned_identity.aks_identity.principal_id
}

output "cluster_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_identity.client_id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}
output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "workload_identity_enabled" {
  description = "Whether workload identity is enabled on the cluster"
  value       = azurerm_kubernetes_cluster.main.workload_identity_enabled
}