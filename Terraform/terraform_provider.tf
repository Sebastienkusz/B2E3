# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config[0].host
    username               = module.aks.kube_config[0].username
    password               = module.aks.kube_config[0].password
    client_certificate     = base64decode(module.aks.kube_config[0].client_certificate)
    client_key             = base64decode(module.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config[0].cluster_ca_certificate)
  }
}

provider "grafana" {
  url  = "https://b2e1-gr2-gateway.westeurope.cloudapp.azure.com" # module.gateway.gateway_fqdn
  auth = "admin:KYNgl8m5UH6MIApscga00k2d"                         # "${local.grafana_admin}:${module.helm.random_password}"
}