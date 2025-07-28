variable "project_environment" {
  description = "The deployment environment (e.g., dev, staging, prod, test)"
  type        = string
}
variable "azure_resource_location" {
  description = "The Azure region where resources will be deployed (e.g., East US, West Europe)"
  type        = string
}
variable "rg_count" {
  description = "The number of resource groups to create"
  type        = number
}
variable "project_name" {
  description = "Project name used for naming conventions and resource identification"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the resource for organization and cost management"
  type        = map(string)
  default     = {}
}