# modules/acr/variables.tf

variable "common_config" {
  description = "Common configuration object"
  type = object({
    project_name         = string
    project_environment  = string
    az_resource_location = string
    tags                 = map(string)
  })
}

variable "az_resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "aks_subnet_id" {
  description = "AKS subnet ID for network access rules"
  type        = string
}

variable "aks_kubelet_identity_object_id" {
  description = "Object ID of AKS kubelet identity for ACR pull access"
  type        = string
}

variable "aks_user_assigned_identity_principal_id" {
  description = "Principal ID of AKS cluster user-assigned identity for CI/CD push"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID for microservice identity access"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}