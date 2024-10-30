
resource "azurerm_storage_account" "demo-azurerm_storage_account" {
  name                     = "stg${var.ade_env_name}${var.env_name}${var.ade_environment_type}"
  resource_group_name      = var.resource_group_name
  location                 = var.ade_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}