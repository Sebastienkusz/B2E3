output "vnet_name" {
  value = azurerm_virtual_network.main.name
  description = "Network name"
}

output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "The ID of the virtual network"
}

output "subnet_ids" {
  value       = { for s in azurerm_subnet.main : s.name => s.id }
  description = "The list of subnet IDs"
}