# Variables générales:
locals {
  subscription_id     = "c56aea2c-50de-4adc-9673-6a8008892c21"
  resource_group_name = "b2e1-gr2"
  location            = data.azurerm_resource_group.main.location
  location_wus        = "WestUS"
  #tenant_id           = "16763265-1998-4c96-826e-c04162b1e041"
}

# Network variables (only 2 networks)
locals {
  network_europe = ["10.1.0.0/16"]
  subnets_europe = ["10.1.1.0/24", "10.1.2.0/24"]
  network_wus    = ["10.10.0.0/16"]
  subnets_wus    = ["10.10.0.0/24"]
}

# Variables pour la machine virtuelle
locals {
  public_ip_allocation_method = "Static"
  vm_domain_name_label        = "${lower(replace(local.resource_group_name, "_", ""))}-vm"
  public_ip_sku               = "Standard"

  vm_size = "Standard_B1s"

  os_disk_caching           = "ReadWrite"
  os_disk_create_option     = "FromImage"
  os_disk_managed_disk_type = "Standard_LRS"

  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  ip_simplon = "82.126.234.200"

  admin_username = "adminuser"
  path           = "/home/${local.admin_username}/.ssh/authorized_keys"
  ssh_key        = tls_private_key.admin_rsa.public_key_openssh

  ssh_ip_filter = concat([for user_value in local.users : user_value.ip], [local.ip_simplon])
}

# Add users 
locals {
  users = {
    antoine = {
      sshkey      = "antoine"
      private_key = "id_rsa"
      ip          = "90.50.33.147"
    }
    sebastien = {
      sshkey      = "sebastien"
      private_key = "sebastien_rsa"
      ip          = "83.195.211.184"
    }
  }
}

# Variables pour l'application Gateway
locals {
  app_domain_name_label = "${local.resource_group_name}-gateway"
  sku_name              = "Standard_v2"
  tier                  = "Standard_v2"
  cookie_based_affinity = "Disabled"
  backend_port          = 80
  backend_protocol      = "Http"
  frontend_port         = 80
  frontend_protocol     = "Http"
  rule_type             = "Basic"
  gateway_name          = "gateway"
}

# Variables pour le cluster AKS
locals {
  aks_name              = "aks"
  aks_domain_name_label = "${local.resource_group_name}-${local.aks_name}"
  pool_name             = "b2e1gr2pool"
  aks_vm_size           = "Standard_A2_v2"
}

# Variables pour le module helm - Prometheus, Grafana, Ingress, Cert-Manager
locals {
  prometheus_chart                = "prometheus"
  prometheus_name                 = "prometheus"
  prometheus_namespace_creation   = true
  prometheus_namespace            = "monitoring"
  prometheus_repository           = "https://prometheus-community.github.io/helm-charts"
  grafana_admin                   = "admin"
  grafana_name                    = "grafana"
  grafana_chart                   = "grafana"
  grafana_namespace               = local.prometheus_namespace
  grafana_repository              = "https://grafana.github.io/helm-charts"
  ingress_chart                   = "ingress-azure"
  ingress_name                    = "ingress-azure"
  ingress_namespace_creation      = true
  ingress_namespace               = "ingress-azure"
  ingress_repository              = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  cert_manager_chart              = "cert-manager"
  cert_manager_name               = "cert-manager"
  cert_manager_namespace_creation = true
  cert_manager_namespace          = "cert-manager"
  cert_manager_repository         = "https://charts.jetstack.io"
}