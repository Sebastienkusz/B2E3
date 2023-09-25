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
  source         = "./modules/vm"
  resource_group = local.resource_group_name
  location       = local.location_wus
  vm_size        = local.vm_size

  os_disk_caching           = local.os_disk_caching
  os_disk_create_option     = local.os_disk_create_option
  os_disk_managed_disk_type = local.os_disk_managed_disk_type

  image_publisher = local.image_publisher
  image_offer     = local.image_offer
  image_sku       = local.image_sku
  image_version   = local.image_version

  admin_username = local.admin_username
  path           = local.path
  ssh_key        = local.ssh_key
  ssh_ip_filter  = local.ssh_ip_filter

  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.vm_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_2_ids)[0]
}

# Create inventory.ini for Ansible
resource "local_file" "inventory" {
  filename        = "${path.root}/../Ansible/inventory.ini"
  file_permission = "0644"
  content         = <<-EOT
[redis]
${module.vm.vm_fqdn}

[redis:vars]
ansible_port=22
ansible_ssh_private_key_file=./../Terraform/${local_file.admin_rsa_file.filename}

[all:vars]
ansible_connection=ssh
ansible_ssh_user=${local.admin_username}
ansible_become=true
EOT
}

resource "null_resource" "playbookconfig" {
  depends_on = [module.vm]
  provisioner "local-exec" {
    working_dir = "${path.root}/../Ansible"
    interpreter = ["bash", "-c"]
    command     = "sleep 100; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook redis-playbook.yml -i inventory.ini"
  }
}

module "gateway" {
  source                      = "./modules/gateway"
  resource_group              = local.resource_group_name
  location                    = local.location
  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.app_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[0]
  name                        = local.gateway_name
  sku_name                    = local.sku_name
  cookie_based_affinity       = local.cookie_based_affinity
  backend_port                = local.backend_port
  backend_protocol            = local.backend_protocol
  frontend_protocol           = local.frontend_protocol
  frontend_port               = local.frontend_port
  rule_type                   = local.rule_type
  tier                        = local.tier
}

module "aks" {
  source                      = "./modules/cluster"
  cluster_name                = local.aks_name
  resource_group              = local.resource_group_name
  location                    = local.location
  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.aks_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[1]
  vm_size                     = local.aks_vm_size
  pool_name                   = local.pool_name
  gateway_id                  = module.gateway.gateway_id
  resource_group_id           = data.azurerm_resource_group.main.id
}

resource "helm_release" "prometheus" {
  depends_on       = [module.aks]
  chart            = "prometheus"
  name             = "prometheus"
  create_namespace = true
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
}

resource "random_password" "grafana" {
  length           = 24
  override_special = "@#"
}

resource "helm_release" "grafana" {
  depends_on = [module.aks, helm_release.prometheus]
  name       = "grafana"
  chart      = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"

  set {
    name  = "adminUser"
    value = "admin"
  }

  set {
    name  = "adminPassword"
    value = random_password.grafana.result
  }
}

# Install nginx ingress controller form helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
resource "helm_release" "ingress-azure" {
  repository       = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart            = "ingress-azure"
  name             = "ingress-azure"
  namespace        = "ingress-azure"
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  skip_crds        = true
  create_namespace = true
  version          = "1.7.2"

  set {
    name  = "appgw.subscriptionId"
    value = local.subscription_id
  }
  set {
    name  = "appgw.resourceGroup"
    value = local.resource_group_name
  }
  set {
    name  = "appgw.name"
    value = module.gateway.gateway_name
  }
  set {
    name  = "appgw.usePrivateIP"
    value = "false"
  }
  set {
    name  = "armAuth.type"
    value = "servicePrincipal"
  }
  set {
    name  = "armAuth.secretJSON"
    value = "$(az ad sp create-for-rbac --role Contributor --scope /subscriptions/${local.subscription_id} --sdk-auth | base64)"
  }
  set {
    name  = "rbac.enabled"
    value = "true"
  }
}