# Vnet and Subnets
module "vnet-europe" {
  source         = "./modules/network"
  resource_group = local.resource_group_name
  vnet_cidr      = local.network_europe
  location       = local.location
  subnet_cidrs   = local.subnets
}

module "vnet-usa" {
  source         = "./modules/network"
  resource_group = local.resource_group_name
  vnet_cidr      = local.network_wus
  location       = local.location_wus
  subnet_cidrs   = local.network_wus
}

# Peering subnets
resource "azurerm_virtual_network_peering" "vnet-1" {
  name                      = "peer1to2"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = module.vnet-europe.vnet_name
  remote_virtual_network_id = module.vnet-usa.vnet_id
}

resource "azurerm_virtual_network_peering" "vnet-2" {
  name                      = "peer2to1"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = module.vnet-usa.vnet_name
  remote_virtual_network_id = module.vnet-europe.vnet_id
}