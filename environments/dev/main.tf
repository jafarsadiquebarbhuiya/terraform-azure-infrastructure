terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}
provider "azurerm" {
  features {}
}

#==============================================================================
#RESOURCE-GROUP
#==============================================================================
module "dev_resourcegroup" {
  source        = "../../modules/resourcegroup"
  common_config = local.common_config
  rg_config     = var.rg_config
}
#==============================================================================
#STORAGE-ACCOUNT
#==============================================================================
module "dev_storageaccount" {
  source            = "../../modules/storage"
  common_config     = local.common_config
  storage_config    = var.storage_config
  az_resource_group = module.dev_resourcegroup.primary_resource_group_name
  depends_on        = [module.dev_resourcegroup]
}
#==============================================================================
#AZURE-NETWORK
#==============================================================================
module "dev_networking" {
  source                  = "../../modules/networking"
  common_config           = local.common_config
  az_resource_group       = module.dev_resourcegroup.primary_resource_group_name
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  depends_on              = [module.dev_resourcegroup]
}
#==============================================================================
#AZURE-KUBERNETES-CLUSTER
#==============================================================================
module "dev_aks" {
  source            = "../../modules/aks"
  common_config     = local.common_config
  az_resource_group = module.dev_resourcegroup.primary_resource_group_name
  subnet_id         = module.dev_networking.aks_subnet_id
  depends_on        = [module.dev_networking]
}
#==============================================================================
#KEYVAULT
#==============================================================================
module "dev_keyvault" {
  source             = "../../modules/keyvault"
  common_config      = local.common_config
  az_resource_group  = module.dev_resourcegroup.primary_resource_group_name
  keyvault_subnet_id = module.dev_networking.keyvault_subnet_id
  depends_on         = [module.dev_networking]
}

#==============================================================================
#KEYVAUAZURE-CONTAINER-REGISTRY
#==============================================================================
data "azurerm_client_config" "current" {}
module "dev_acr" {
  source = "../../modules/acr"

  # Common configuration
  common_config     = local.common_config
  az_resource_group = module.dev_resourcegroup.primary_resource_group_name

  # ACR specific configuration
  acr_sku = "Standard" # Change to "Premium" for production

  # Network integration
  aks_subnet_id = module.dev_networking.aks_subnet_id

  # AKS integration
  aks_kubelet_identity_object_id          = module.dev_aks.kubelet_identity_object_id
  aks_user_assigned_identity_principal_id = module.dev_aks.cluster_identity_principal_id

  # Key Vault integration
  key_vault_id = module.dev_keyvault.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  # Security configuration
  allowed_ip_ranges = [
    "106.215.140.107/32",
    "172.203.7.49/32",
    "20.109.92.212/32"
  ]

  # Optional: Enable for CI/CD scenarios
  enable_aks_push_access = true

  # Optional: Enable for enhanced security
  enable_private_endpoint    = false
  private_endpoint_subnet_id = null # module.network.private_endpoint_subnet_id
  private_dns_zone_ids       = []   # [module.network.private_dns_zone_id]

  depends_on = [module.dev_aks, module.dev_keyvault, module.dev_networking]
}