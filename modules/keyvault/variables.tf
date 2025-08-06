variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "keyvault_subnet_id" {
  description = "Subnet ID for Key Vault"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
