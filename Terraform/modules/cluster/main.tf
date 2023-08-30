# Création de l'adresse IP publique du cluster
resource "azurerm_public_ip" "main" {
  name                = "${var.resource_group}-${var.cluster_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group
  domain_name_label   = var.domain_name_label
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

# Création du groupe de sécurité réseau pour la passerelle d'application
resource "azurerm_network_security_group" "main" {
  name                = "${var.resource_group}-${var.cluster_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_security_rule" "main" {
  name                        = "Allow-HTTP-outbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.main.name
}

# Association du NSG au sous-réseau du cluster
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_user_assigned_identity" "main" {
  name                = "${var.resource_group}-${var.cluster_name}-identity"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_role_assignment" "ra1" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "ra3" {
  scope                = var.gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

resource "azurerm_role_assignment" "ra4" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.resource_group}-${var.cluster_name}"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.resource_group}-${var.cluster_name}"
  node_resource_group = "${var.resource_group}-${var.cluster_name}-node"

  ingress_application_gateway {
    gateway_id = var.gateway_id
  }

  default_node_pool {
    name            = var.pool_name
    node_count      = 3
    vm_size         = var.vm_size
    max_pods        = 30
    os_disk_size_gb = 100
    vnet_subnet_id  = var.subnet_id
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.main.id
    ]
  }
}
