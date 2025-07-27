
variable "project_environment" {
  type = string

}
variable "azure_resource_location" {
  type = string

}
variable "rg_count" {
  type = number

}


#=========================================================#
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["DEV", "STG", "PROD"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "jafar"
}

variable "business_unit" {
  description = "Business unit"
  type        = string
  default     = "adp"
}

variable "subscription_name" {
  description = "Azure subscription identifier"
  type        = string
  default     = "jafar_devops"
}

variable "project_name" {
  description = "Project name"
  type        = string
}