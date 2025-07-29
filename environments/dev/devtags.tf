locals {
  common_tags = {
    Environment  = var.environment
    Owner        = var.owner
    BusinessUnit = var.business_unit
    Subscription = var.subscription_name
    ManagedBy    = "terraform"
    CreatedDate  = formatdate("YYYY-MM-DD", timestamp())
    Project      = var.project
  }
}
locals {
  # Define common variables once
  common_config = {
    project_name         = var.project_name
    project_environment  = var.project_environment
    az_resource_location = var.az_resource_location
    tags                 = local.common_tags
  }
}