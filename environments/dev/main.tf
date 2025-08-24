terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
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
#AZURE-CONTAINER-REGISTRY
#==============================================================================
module "dev_acr" {
  source = "../../modules/acr"

  common_config                           = local.common_config
  az_resource_group                       = module.dev_resourcegroup.primary_resource_group_name
  aks_subnet_id                           = module.dev_networking.aks_subnet_id
  aks_kubelet_identity_object_id          = module.dev_aks.kubelet_identity_object_id
  aks_user_assigned_identity_principal_id = module.dev_aks.cluster_identity_principal_id
  key_vault_id                            = module.dev_keyvault.keyvault_id
  depends_on                              = [module.dev_aks, module.dev_keyvault, module.dev_networking]
}

#==============================================================================
#KEYVAUL-IDENTITY
#==============================================================================
module "dev_keyvaultidentity" {
  source = "../../modules/security/workloadidentity/keyvault"

  common_config       = local.common_config
  az_resource_group   = module.dev_resourcegroup.primary_resource_group_name
  key_vault_id        = module.dev_keyvault.keyvault_id
  aks_oidc_issuer_url = module.dev_aks.oidc_issuer_url

  # Optional: customize these if needed
  kubernetes_namespace       = "default"
  kubernetes_service_account = "workload-identity-sa"

  depends_on = [module.dev_aks, module.dev_keyvault]
}