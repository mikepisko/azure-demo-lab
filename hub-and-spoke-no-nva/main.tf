resource "azurerm_resource_group" "rg" {
  name     = var.resourcegroup_name
  location = var.location
  tags    = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  access_tier              = var.storage_access_tier
  public_network_access_enabled = var.public_network_access_enabled
  
}