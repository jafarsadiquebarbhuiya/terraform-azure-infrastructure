#common-vars
project_name         = "demo"
project_environment  = "dev"
az_resource_location = "East US"

#tags-vars
subscription_name = "jafar_devops"
owner             = "jafar"
business_unit     = "adp"
environment       = "DEV"
project           = "DEMO"

#resourcegroup-vars



#storageaccount-vars



rg_config = {
  rg_count = 1
}

#storageaccount-vars
storage_config = {
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"
  storage_count                    = 1


}   