resource "random_string" "resource_code" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  #name                     = lower(replace(replace("${local.resource_group_name}tfstate", "_", ""), "-", ""))
  name                     = lower(replace(replace("${local.resource_group_name}${random_string.resource_code.result}", "_", ""), "-", ""))
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = lower("${random_string.resource_code.result}") #"tfstate" #
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Create backend.tf in Terraform folder
resource "local_file" "backend" {
  filename        = "${path.root}/../backend.tf"
  file_permission = "0644"
  content         = <<-EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${local.resource_group_name}"
    storage_account_name = "${lower(replace(replace("${local.resource_group_name}${random_string.resource_code.result}", "_", ""), "-", ""))}"
    container_name       = "${lower("${random_string.resource_code.result}")}"
    key                  = "${local.resource_group_name}/terraform.tfstate"
  }
}
EOT

  depends_on = [
    azurerm_storage_container.tfstate
  ]
}