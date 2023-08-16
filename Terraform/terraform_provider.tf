# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.62.1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

# Configure the Ansible Provider
provider "ansible" {
}