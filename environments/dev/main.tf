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
