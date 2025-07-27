locals {
  common_tags = {
    Environment  = var.environment
    Owner        = var.owner
    BusinessUnit = var.business_unit
    Subscription = var.subscription_name
    ManagedBy    = "terraform"
    CreatedDate  = formatdate("YYYY-MM-DD", timestamp())
    Project      = var.project_name
  }
}