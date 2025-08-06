variable "common_config" {
  description = "Common configuration shared across modules"
  type = object({
    project_name         = string
    project_environment  = string
    az_resource_location = string
    tags                 = map(string)
  })
}
variable "az_resource_group" {
  description = "Resource group name where storage account will be created"
  type        = string
}

variable "vnet_address_space" {
  description = "Virtual Network address space"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes"
  type        = map(list(string))
}
