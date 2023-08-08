
resource "azurerm_virtual_machine" "main" {
    name = "${local.resource_group_name}-vm"
    location = var.location
    resource_group = var.resource_group
  network_interface_ids = [azurerm_network_interface.vm-bastion-nic.id]
  vm_size               = local.vm_size_bastion


  storage_os_disk {
    name              = local.os_disk_name
    caching           = local.os_disk_caching
    create_option     = local.os_disk_create_option
    managed_disk_type = local.os_disk_managed_disk_type
  }

  storage_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  os_profile {
    computer_name  = "${local.resource_group_name}-vm"
    admin_username = local.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = local.ssh_key
    }
  }
}
