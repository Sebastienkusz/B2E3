terraform {
  backend "azurerm" {
    resource_group_name  = "b2e1-gr2"
    storage_account_name = "b2e1gr22i2tsn"
    container_name       = "2i2tsn"
    key                  = "b2e1-gr2/terraform.tfstate"
  }
}
