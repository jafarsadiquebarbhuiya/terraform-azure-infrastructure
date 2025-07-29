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
  source = "../../modules/resourcegroup"

  common_config = local.common_config
  rg_config     = var.rg_config
}
module "dev_storageaccount" {
  source            = "../../modules/storage"
  common_config     = local.common_config
  storage_config    = var.storage_config
  az_resource_group = module.dev_resourcegroup.primary_resource_group_name
  depends_on        = [module.dev_resourcegroup]
}

