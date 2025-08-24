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
