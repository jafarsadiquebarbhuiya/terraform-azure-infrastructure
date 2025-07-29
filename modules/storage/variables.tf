variable "common_config" {
  description = "Common configuration shared across modules"
  type = object({
    project_name         = string
    project_environment  = string
    az_resource_location = string
    tags                 = map(string)
  })
}

variable "storage_config" {
  description = "Storage account specific configuration"
  type = object({

    storage_account_tier             = string
    storage_account_replication_type = string
    storage_count                    = number
  })
}

variable "az_resource_group" {
  description = "Resource group name where storage account will be created"
  type        = string
}