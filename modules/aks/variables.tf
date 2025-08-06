variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "system_node_count" {
  description = "Number of system nodes"
  type        = number
  default     = 3
}

variable "user_node_count" {
  description = "Number of user nodes"
  type        = number
  default     = 3
}

variable "subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs for cluster admins"
  type        = list(string)
  default     = []
}

variable "acr_id" {
  description = "Azure Container Registry ID"
  type        = string
  default     = null
}

#=============================
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
