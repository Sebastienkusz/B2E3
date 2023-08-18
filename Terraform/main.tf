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

  depends_on = [
    local_file.admin_rsa_file
  ]
}

resource "null_resource" "playbookconfig" {
  depends_on = [module.vm]
  provisioner "local-exec" {
    working_dir = "${path.root}/../Ansible"
    interpreter = [ "bash", "-c" ]
    command = "sleep 60; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook redis-playbook.yml -i inventory.ini"
  }
}

# resource "ansible_host" "main" {
#   name   = module.vm.vm_fqdn
#   groups = ["redis"]
#   variables = {
#     ansible_connection           = "ssh",
#     ansible_ssh_user             = "${local.admin_username}",
#     ansible_ssh_private_key_file = "${local_file.admin_rsa_file.filename}",
#     ansible_ssh_host             = "${module.vm.vm_fqdn}"
#     ansible_become               = true,
#     ansible_python_interpreter   = "/usr/bin/python3",
#     ansible_ssh_extra_args       = "-o StrictHostKeyChecking=no"
#   }
# }

# resource "ansible_playbook" "playbook" {
#   depends_on = [module.vm]
#   playbook   = "./test-playbook.yml"
#   name       = ansible_host.main.name
# }


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
}

resource "local_sensitive_file" "kube_config" {
  content = module.aks.kube_config
  filename = "./kubeconfig"
}

# Pour test ------------------------------------------------------------------
module "aks2" {
  source                      = "./modules/cluster"
  cluster_name                = local.aks2_name
  resource_group              = local.resource_group_name
  location                    = local.location
  public_ip_allocation_method = local.public_ip_allocation_method
  domain_name_label           = local.aks2_domain_name_label
  public_ip_sku               = local.public_ip_sku
  subnet_id                   = values(module.vnet.subnet_1_ids)[2]
  vm_size                     = local.aks2_vm_size
  pool_name                   = local.pool2_name
}

resource "local_sensitive_file" "kube_config2" {
  content = module.aks2.kube_config
  filename = "./kubeconfig2"
}
# -----------------------------------------------------------------------------

resource "helm_release" "prometheus" {
  depends_on = [module.aks, local_sensitive_file.kube_config]
  chart      = "prometheus"
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
}

resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana.result
  }
}

resource "random_password" "grafana" {
  length = 24
}

resource "helm_release" "grafana" {
  depends_on = [module.aks, helm_release.prometheus, local_sensitive_file.kube_config]
  name  = "grafana"
  chart = "grafana"
  repository = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
      admin_user_key        = "admin-user"
      admin_password_key    = "admin-password"
      prometheus_svc        = "${helm_release.prometheus.name}-server"
      replicas              = 1
    })
  ]
}