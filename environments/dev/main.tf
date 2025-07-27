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


# Resource Group
resource "azurerm_resource_group" "dev_rg" {
  count    = var.rg_count
  name     = "rg-${var.project_name}-${var.project_environment}-${count.index}"
  location = var.azure_resource_location
  tags     = local.common_tags
}






# # Networking Module
# module "networking" {
#   source = "../../modules/networking"

#   environment         = local.environment
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   vnet_address_space  = var.vnet_address_space
#   subnet_config       = var.subnet_config

#   tags = local.common_tags
# }

# # Storage Module
# module "storage" {
#   source = "../../modules/storage"

#   environment         = local.environment
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   storage_config      = var.storage_config

#   tags = local.common_tags
# }

# # Security Module
# module "security" {
#   source = "../../modules/security"

#   environment         = local.environment
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location

#   tags = local.common_tags
# }
