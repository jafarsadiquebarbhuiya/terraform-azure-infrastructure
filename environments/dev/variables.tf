
variable "project_environment" {
  type = string

}
variable "az_resource_location" {
  type = string

}
variable "rg_count" {
  type = number

}
variable "project_name" {
  description = "Project name"
  type        = string
}

#=========================================================#
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