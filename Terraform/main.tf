# Vnet, Subnets and Peering
module "vnet" {
  source         = "./modules/network"
  resource_group = local.resource_group_name
  vnet_1         = local.network_europe
  vnet_2         = local.network_wus
  subnet_1       = local.subnets_europe
  subnet_2       = local.subnets_wus
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