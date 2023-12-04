# Création de l'adresse IP publique de la passerelle d'application
resource "azurerm_public_ip" "main" {
  name                = "${var.resource_group}-gateway-ip"
  location            = var.location
  resource_group_name = var.resource_group
  domain_name_label   = var.domain_name_label
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

# Création du groupe de sécurité réseau pour la passerelle d'application
# resource "azurerm_network_security_group" "main" {
#   name                = "${var.resource_group}-gateway-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group
# }

# # Règle de sécurité pour la tranche de port 65200-65535 depuis n'importe quelle source sur la passerelle d'application ( Norme V2)
# resource "azurerm_network_security_rule" "main" {
#   name                        = "${var.resource_group}-gateway-nsg-rule"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "65200-65535"
#   source_address_prefix       = "GatewayManager"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group
#   network_security_group_name = azurerm_network_security_group.main.name
# }

# resource "azurerm_network_security_rule" "second" {
#   name                        = "Allow-HTTP-Inbound"
#   priority                    = 110
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group
#   network_security_group_name = azurerm_network_security_group.main.name
# }

# # Association du NSG au sous-réseau de la passerelle
# resource "azurerm_subnet_network_security_group_association" "app-gateway-subnet-nsg" {
#   subnet_id                 = var.subnet_id
#   network_security_group_id = azurerm_network_security_group.main.id
# }

resource "azurerm_application_gateway" "main" {
  name                = "${var.resource_group}-gateway"
  resource_group_name = var.resource_group
  location            = var.location

  backend_address_pool {
    name = var.name
    # ip_addresses =  IP PRIVEE CLUSTER AKS
  }

  backend_http_settings {
    cookie_based_affinity = var.cookie_based_affinity
    name                  = var.name
    port                  = var.backend_port
    protocol              = var.backend_protocol
  }

  frontend_ip_configuration {
    name                 = var.name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  frontend_port {
    name = var.name
    port = var.frontend_port
  }

  gateway_ip_configuration {
    name      = var.name
    subnet_id = var.subnet_id
  }

  http_listener {
    name                           = var.name
    frontend_ip_configuration_name = var.name
    frontend_port_name             = var.name
    protocol                       = var.frontend_protocol
  }

  request_routing_rule {
    name                       = var.name
    priority                   = 1
    rule_type                  = var.rule_type
    http_listener_name         = var.name
    backend_address_pool_name  = var.name
    backend_http_settings_name = var.name
  }

  sku {
    name = var.sku_name
    tier = var.tier
  }
  autoscale_configuration {
    min_capacity = 0
    max_capacity = 3
  }

  lifecycle {
    ignore_changes = [
      tags["managed-by-k8s-ingress"],
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      ssl_certificate,
      url_path_map
    ]
  }

}