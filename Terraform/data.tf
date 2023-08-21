data "azurerm_resource_group" "main" {
  name = local.resource_group_name
}

data "azurerm_kubernetes_cluster" "main" {
  depends_on       = [module.aks]
  name                = "${local.resource_group_name}-${local.aks_name}"
  resource_group_name = local.resource_group_name
}