variable "common_config" {
  description = "Common configuration shared across modules"
  type = object({
    project_name         = string
    project_environment  = string
    az_resource_location = string
    tags                 = map(string)
  })
}
variable "rg_config" {
  description = "Resource Group Specific Configurationue"
  type = object({
    rg_count = number
  })

}