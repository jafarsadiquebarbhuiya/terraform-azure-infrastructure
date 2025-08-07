# modules/acr/main.tf

# Get current client configuration
data "azurerm_client_config" "current" {}

# Get current public IP
data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com"
}

# Define IP rules similar to Key Vault module
locals {
  current_ip = chomp(data.http.current_ip.response_body)
  static_ip_rules = [
    "106.215.140.107/32",
    "172.203.7.49/32",
    "20.109.92.212/32"
  ]
  # Merge static IPs, current IP, and any additional allowed IPs
  all_ip_rules = distinct(concat(local.static_ip_rules, ["${local.current_ip}/32"], var.allowed_ip_ranges))
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.common_config.project_name}${var.common_config.project_environment}"
  resource_group_name = var.az_resource_group
  location            = var.common_config.az_resource_location
  sku                 = var.acr_sku
  admin_enabled       = false

  # Enable system-assigned managed identity for ACR operations
  identity {
    type = "SystemAssigned"
  }

  # Network access configuration
  network_rule_set {
    default_action = "Deny"

    # Allow access from AKS subnet
    virtual_network {
      action    = "Allow"
      subnet_id = var.aks_subnet_id
    }

    # Use the merged IP rules from locals
    ip_rules = local.all_ip_rules
  }

  # Enable vulnerability scanning and other premium features
  dynamic "georeplications" {
    for_each = var.acr_sku == "Premium" ? var.geo_replications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
    }
  }

  tags = var.common_config.tags
}

# Role assignment for AKS kubelet identity to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_kubelet_identity_object_id
}

# Role assignment for AKS managed identity to push images during CI/CD
resource "azurerm_role_assignment" "aks_acr_push" {
  count                = var.enable_aks_push_access ? 1 : 0
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = var.aks_user_assigned_identity_principal_id
}

# Create user-assigned managed identity for microservice deployments
resource "azurerm_user_assigned_identity" "microservice_identity" {
  name                = "identity-microservices-${var.common_config.project_name}-${var.common_config.project_environment}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  tags                = var.common_config.tags
}

# Grant microservice identity ACR pull access
resource "azurerm_role_assignment" "microservice_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.microservice_identity.principal_id
}

# Grant microservice identity Key Vault secrets access
resource "azurerm_key_vault_access_policy" "microservice_keyvault_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.microservice_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Private endpoint for ACR (optional for enhanced security)
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "pe-${azurerm_container_registry.acr.name}"
  location            = var.common_config.az_resource_location
  resource_group_name = var.az_resource_group
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_container_registry.acr.name}"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-group-${azurerm_container_registry.acr.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.common_config.tags
}