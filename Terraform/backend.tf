terraform {
  backend "azurerm" {
    resource_group_name  = "b2e1-gr2"
    storage_account_name = "b2e1gr2tfstate"
    container_name       = "tfstate"
    key                  = "b2e1-gr2/terraform.tfstate"
  }
}