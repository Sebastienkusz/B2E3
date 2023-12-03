# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.62.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.3.3"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}