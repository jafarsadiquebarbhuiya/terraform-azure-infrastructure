output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "keyvault_subnet_id" {
  value = azurerm_subnet.keyvault_subnet.id
}