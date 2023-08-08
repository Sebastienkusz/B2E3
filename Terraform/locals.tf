data "azurerm_resource_group" "main" {
    name = local.resource_group_name 
}


# Variables générales:
locals {
    resource_group_name = data.azurerm_resource_group.main.name
    location = data.azurerm_resource_group.main.location
    location_wus = "West US"
}

# Variables pour la machine virtuelle
locals {
  os_disk_name     = "${local.resource_group_name}-vm"
  os_disk_caching           = "ReadWrite"
  os_disk_create_option     = "FromImage"
  os_disk_managed_disk_type = "Standard_LRS"

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  admin_username = "adminuser"
  ssh_key        = file("~/.ssh/b2e1-gr2-key.pub")
}