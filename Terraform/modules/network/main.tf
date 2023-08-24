resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.resource_group}-vnet-${lower(var.location_1)}"
  location            = var.location_1
  resource_group_name = var.resource_group
  address_space       = var.vnet_1
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.resource_group}-vnet-${lower(var.location_2)}"
  location            = var.location_2
  resource_group_name = var.resource_group
  address_space       = var.vnet_2
}

resource "azurerm_subnet" "subnet1" {
  for_each             = toset(var.subnet_1)
  name                 = "${var.resource_group}-subnet-${index(var.subnet_1, each.key)}"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = var.resource_group
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "subnet2" {
  for_each             = toset(var.subnet_2)
  name                 = "${var.resource_group}-subnet-${index(var.subnet_2, each.key)}"
  virtual_network_name = azurerm_virtual_network.vnet2.name
  resource_group_name  = var.resource_group
  address_prefixes     = [each.value]
}

# Peering subnets
resource "azurerm_virtual_network_peering" "vnet-1" {
  name                      = "${var.resource_group}-peer1to2"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnet-2" {
  name                      = "${var.resource_group}-peer2to1"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}