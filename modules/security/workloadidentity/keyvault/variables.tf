# ../../modules/security/workloadidentity/keyvault/variables.tf

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
  description = "Resource group name where resources will be created"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault to grant access to"
  type        = string
}

variable "aks_oidc_issuer_url" {
  description = "OIDC issuer URL from the AKS cluster"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the service account"
  type        = string
  default     = "default"
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name"
  type        = string
  default     = "workload-identity-sa"
}