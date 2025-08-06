resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.common_config.project_name}-${var.common_config.project_environment}"
  address_space       = var.vnet_address_space
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks-${var.common_config.project_name}-${var.common_config.project_environment}"
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes["aks"]
}

resource "azurerm_subnet" "keyvault_subnet" {
  name                 = "snet-keyvault-${var.common_config.project_name}-${var.common_config.project_environment}"
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes["keyvault"]

  service_endpoints = ["Microsoft.KeyVault"]
}

resource "azurerm_network_security_group" "aks_nsg" {
  name                = "nsg-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.common_config.tags
}

resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}