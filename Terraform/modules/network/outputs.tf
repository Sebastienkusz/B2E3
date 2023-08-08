output "subnet_ids" {
  value       = { for s in azurerm_subnet.main : s.name => s.id }
  description = "The list of subnet IDs"
}