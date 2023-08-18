output "cluster_name" {
  value       = azurerm_kubernetes_cluster.main.name
  description = "The name of the cluster"
}

output "cluster_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "The ID of the cluster"
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}