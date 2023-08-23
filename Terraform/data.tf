data "azurerm_resource_group" "main" {
  name = local.resource_group_name
}

# data "azurerm_kubernetes_cluster" "main" {
#   name = module.aks.cluster_name
#   resource_group_name = local.resource_group_name
# }