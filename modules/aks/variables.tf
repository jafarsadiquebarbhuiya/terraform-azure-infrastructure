variable "cluster_name" {
  description = "Name of the AKS cluster"
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

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.3"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}