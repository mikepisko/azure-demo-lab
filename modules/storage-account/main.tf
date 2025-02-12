resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_base_name}${var.random_string}${var.storage_account_region}"
  resource_group_name      = var.resourcegroup_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  access_tier              = var.storage_access_tier
  public_network_access_enabled = var.public_network_access_enabled
  
}