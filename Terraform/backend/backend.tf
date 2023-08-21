resource "azurerm_storage_account" "tfstate" {
  name                     = lower(replace(replace("${local.resource_group_name}tfstate", "_", ""), "-", ""))
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Create backend.tf
resource "local_file" "backend" {
  filename        = "${path.root}/../backend.tf"
  file_permission = "0644"
  content         = <<-EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${local.resource_group_name}"
    storage_account_name = "${lower(replace("${local.resource_group_name}", "-", ""))}tfstate"
    container_name       = "tfstate"
    key                  = "${local.resource_group_name}/terraform.tfstate"
  }
}
EOT

  depends_on = [
    azurerm_storage_container.tfstate
  ]
}