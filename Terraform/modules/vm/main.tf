resource "azurerm_public_ip" "main" {
  name                = "${var.resource_group}-vm-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = var.public_ip_allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.public_ip_sku
}

resource "azurerm_network_interface" "main" {
  name                = "${var.resource_group}-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_group}-vm-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.resource_group}-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Règle de sécurité pour le port 22 (SSH) depuis n'importe quelle source sur le serveur Redis
resource "azurerm_network_security_rule" "main" {
  name                        = "Allow-SSH-Inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_network_interface.main.private_ip_address
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_virtual_machine" "main" {
  name                          = "${var.resource_group}-vm"
  location                      = var.location
  resource_group_name           = var.resource_group
  network_interface_ids         = [azurerm_network_interface.main.id]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "${var.resource_group}-vm"
    caching           = var.os_disk_caching
    create_option     = var.os_disk_create_option
    managed_disk_type = var.os_disk_managed_disk_type
  }

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_profile {
    computer_name  = "${var.resource_group}-vm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = var.path
      key_data = var.ssh_key
    }
  }

  # provisioner "local-exec" {
  #   working_dir = "${path.cwd}/../Ansible"
  #   interpreter = ["/bin/bash"]
  #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook redis-playbook.yml -i inventory.ini"
  # }

}
