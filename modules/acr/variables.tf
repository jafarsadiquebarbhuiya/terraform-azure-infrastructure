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

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
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
  description = "Principal ID of AKS cluster user-assigned identity"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "Key Vault ID for microservice identity access"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "allowed_ip_ranges" {
  description = "Additional IP ranges allowed to access ACR (beyond the default static IPs and current IP)"
  type        = list(string)
  default     = []
}
variable "enable_aks_push_access" {
  description = "Enable AKS identity to push images to ACR"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for ACR"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs for private endpoint"
  type        = list(string)
  default     = []
}

variable "geo_replications" {
  description = "List of geo-replication configurations for Premium SKU"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
  }))
  default = []
}