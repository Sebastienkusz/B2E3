terraform {
  backend "azurerm" {
    resource_group_name  = "b2e1-gr2"
    storage_account_name = "b2e1gr279ozk0"
    container_name       = "79ozk0"
    key                  = "b2e1-gr2/terraform.tfstate"
  }
}
