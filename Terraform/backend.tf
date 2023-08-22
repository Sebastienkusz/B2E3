terraform {
  backend "azurerm" {
    resource_group_name  = "b2e1-gr2"
    storage_account_name = "b2e1gr2gky1ht"
    container_name       = "gky1ht"
    key                  = "b2e1-gr2/terraform.tfstate"
  }
}
