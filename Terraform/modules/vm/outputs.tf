output "vm_name" {
  value       = azurerm_virtual_machine.main.name
  description = "The name of the virtual machine"
}

output "vm_id" {
  value       = azurerm_virtual_machine.main.id
  description = "The ID of the virtual machine"
}

output "vm_fqdn" {
  value       = azurerm_public_ip.main.fqdn
  description = "The fqdn of the virtual machine"
}