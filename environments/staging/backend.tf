terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatejafar4600"
    container_name       = "tfstate"
    key                  = "staging/terraform.tfstate"
  }
}
