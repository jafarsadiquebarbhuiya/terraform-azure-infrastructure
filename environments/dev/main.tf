terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
}
# provider "azurerm" {
#   features {
#     key_vault {
#       purge_soft_delete_on_destroy    = true
#       recover_soft_deleted_key_vaults = true
#     }
#   }
# }
module "dev_resourcegroup" {
  source                  = "../../modules/resourcegroup"
  project_name            = var.project_name
  project_environment     = var.project_environment
  azure_resource_location = var.azure_resource_location
  rg_count                = var.rg_count
  tags                    = local.common_tags
}



# Storage Module
# module "dev_storageaccount" {
#   source = "../../modules/storage"

#   environment         = local.environment
#   resource_group_name = module.azurerm_resource_group.
#   location            = azurerm_resource_group.main.location
#   storage_config      = var.storage_config

#   tags = local.common_tags
# }

