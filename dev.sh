cat > environments/dev/variables.tf << 'EOF'
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myapp"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnet_config" {
  description = "Subnet configuration"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
}

variable "storage_config" {
  description = "Storage configuration"
  type = object({
    account_tier     = string
    replication_type = string
  })
}
EOF

cat > environments/dev/main.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Local values for the environment
locals {
  environment = "dev"
  location    = "East US"
  
  common_tags = {
    Environment = local.environment
    Project     = var.project_name
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${local.environment}"
  location = local.location
  tags     = local.common_tags
}

# Networking Module
module "networking" {
  source = "../../modules/networking"
  
  environment         = local.environment
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  vnet_address_space = var.vnet_address_space
  subnet_config      = var.subnet_config
  
  tags = local.common_tags
}

# Storage Module
module "storage" {
  source = "../../modules/storage"
  
  environment         = local.environment
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  storage_config     = var.storage_config
  
  tags = local.common_tags
}

# Security Module
module "security" {
  source = "../../modules/security"
  
  environment         = local.environment
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  
  tags = local.common_tags
}
EOF

cat > environments/dev/terraform.tfvars << 'EOF'
project_name = "myapp"
owner        = "platform-team@company.com"

vnet_address_space = ["10.0.0.0/16"]

subnet_config = {
  web = {
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Web"]
  }
  app = {
    address_prefixes  = ["10.0.2.0/24"]
    service_endpoints = ["Microsoft.Storage"]
  }
  db = {
    address_prefixes  = ["10.0.3.0/24"]
    service_endpoints = ["Microsoft.Sql"]
  }
}

storage_config = {
  account_tier     = "Standard"
  replication_type = "LRS"
}
EOF

cat > environments/dev/outputs.tf << 'EOF'
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = module.networking.vnet_id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = module.storage.storage_account_name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.security.key_vault_uri
}
EOF