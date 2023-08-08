resource "azurerm_virtual_network" "main" {
  name                = "vnet"
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



# az network vnet peering create -g MyResourceGroup -n MyVnet1ToMyVnet2 --vnet-name MyVnet1 --remote-vnet MyVnet2Id --allow-vnet-access