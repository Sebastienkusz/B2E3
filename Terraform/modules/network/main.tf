resource "azurerm_virtual_network" "main" {
  name                = "vnet-${lower(var.location)}"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  for_each             = toset(var.subnet_cidrs)
  name                 = "subnet-${index(var.subnet_cidrs, each.key)}"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group
  address_prefixes     = [each.value]
}