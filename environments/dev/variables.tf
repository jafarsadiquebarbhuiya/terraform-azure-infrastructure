#==============================================================================
#COMMON-CONFIG
#==============================================================================
variable "project_environment" {
  type = string
}
variable "az_resource_location" {
  type = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}
#==============================================================================
#COMMON-TAGS
#==============================================================================
variable "environment" {
  description = "Environment name (DEV, STAGE, PROD)"
  type        = string
  validation {
    condition     = contains(["DEV", "STG", "PROD"], var.environment)
    error_message = "Environment must be DEV, STAGE, or PROD."
  }
}
variable "owner" {
  description = "Resource owner"
  type        = string
}
variable "business_unit" {
  description = "Business unit"
  type        = string
}
variable "subscription_name" {
  description = "Azure subscription identifier"
  type        = string
}
variable "project" {
  description = "Project name"
  type        = string
}
#==============================================================================
#RESOURCE-GROUP
#==============================================================================
variable "rg_config" {
  description = "Resource Group Specific Configuration"
  type = object({
    rg_count = number
  })
}
#==============================================================================
#STORAGE-ACCOUNT
#==============================================================================
variable "storage_config" {
  description = "Storage account specific configuration"
  type = object({
    storage_account_tier             = string
    storage_account_replication_type = string
    storage_count                    = number
  })
}

variable "vnet_address_space" {
  description = "Virtual Network address space"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes"
  type        = map(list(string))
}

# variable "subnet_id" {
#   description = "Subnet ID for AKS"
#   type        = string
# }