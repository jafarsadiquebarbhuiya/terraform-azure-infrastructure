#==============================================================================
#COMMON-CONFIG
#==============================================================================
project_name         = "demo"
project_environment  = "dev"
az_resource_location = "East US"

#==============================================================================
#COMMON-TAGS
#==============================================================================
subscription_name = "jafar_devops"
owner             = "jafar"
business_unit     = "adp"
environment       = "DEV"
project           = "DEMO"

#==============================================================================
#RESOURCE-GROUP
#==============================================================================
rg_config = {
  rg_count = 1
}
#==============================================================================
#STORAGE-ACCOUNT
#==============================================================================
storage_config = {
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"
  storage_count                    = 1


}

#vnet-vars
vnet_address_space = ["10.1.0.0/16"]

subnet_address_prefixes = {
  aks      = ["10.1.1.0/24"]
  keyvault = ["10.1.2.0/24"]
}