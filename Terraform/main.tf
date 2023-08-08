# Vnet and Subnets
module "vnet-europe" {
  source         = "./modules/network"
  version        = "1.0.2"
  resource_group = local.resource_group_name
  vnet_cidr      = local.network_base
  location       = local.location
  subnet_cidrs   = local.subnets
}

module "vnet-usa" {
  source         = "./modules/network"
  version        = "1.0.2"
  resource_group = local.resource_group_name
  vnet_cidr      = local.network_base
  location       = local.location_wus
  subnet_cidrs   = local.subnets[0]
}