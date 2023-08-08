data "azurerm_resource_group" "main" {
    name = local.resource_group_name 
}

# Variables générales:
locals {
    subscription_id     = "c56aea2c-50de-4adc-9673-6a8008892c21"
    resource_group_name = "b2e1-gr2"
    location = data.azurerm_resource_group.main.location
    location_wus = "WestUS"
}

# Network variables
locals {
  network_europe = ["10.1.0.0/16"]
  subnets      = ["10.1.1.0/24", "10.1.2.0/24"]
  network_wus = ["10.2.0.0/16"]
  
}


Variables pour la machine virtuelle
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