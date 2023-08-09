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

module "vm" {
  source = "./modules/vm"
  resource_group = local.resource_group_name
  location = local.location_wus
  vm_size = local.vm_size

  os_disk_caching = local.os_disk_caching
  os_disk_create_option = local.os_disk_create_option
  os_disk_managed_disk_type = local.os_disk_managed_disk_type

  image_publisher = local.image_publisher
  image_offer = local.image_offer
  image_sku = local.image_sku
  image_version = local.image_version

  admin_username = local.admin_username
  path = local.path
  ssh_key = local.ssh_key

  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label = local.vm_domain_name_label
  public_ip_sku = local.public_ip_sku

}