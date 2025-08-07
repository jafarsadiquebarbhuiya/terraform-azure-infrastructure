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
#AZURE KUBERNETES CLUSTER
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

