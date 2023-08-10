output "vnet_1_name" {
  value = azurerm_virtual_network.main1.name
  description = "Network name"
}

output "vnet_2_name" {
  value = azurerm_virtual_network.main2.name
  description = "Network name"
}

output "vnet_1_id" {
  value       = azurerm_virtual_network.main1.id
  description = "The ID of the virtual network"
}

output "vnet_2_id" {
  value       = azurerm_virtual_network.main2.id
  description = "The ID of the virtual network"
}

output "subnet_1_ids" {
  value       = { for s in azurerm_subnet.main1 : s.name => s.id }
  description = "The list of subnet IDs"
}

output "subnet_2_ids" {
  value       = { for s in azurerm_subnet.main2 : s.name => s.id }
  description = "The list of subnet IDs"
}