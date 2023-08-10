output "gateway_name" {
  value       = azurerm_application_gateway.main.name
  description = "The name of the Gateway"
}

output "gateway_id" {
  value       = azurerm_application_gateway.main.id
  description = "The ID of the Gateway"
}