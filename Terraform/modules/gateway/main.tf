
/*
ressource "azurerm_application_gateway" "main" {
    name = "${local.resource_group_name}-app-gateway"
    resource_group = var.resource_group
    location = var.location
    enable_http2 = true
    
    sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 3
  }
}
*/

