variable "keyvault_subnet_id" {
  description = "Subnet ID for Key Vault"
  type        = string
}

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
variable "aks_cluster_identity_principal_id" {
  description = "AKS cluster identity principal ID"
  type        = string
}