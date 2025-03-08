resource "azurerm_private_dns_zone" "private_dns_zones" {
  count = length(var.private_dns_zone_names)

  name                = var.private_dns_zone_names[count.index]
  resource_group_name = var.resourcegroup_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_links" {
  count = length(var.private_dns_zone_names)

  name                  = "${azurerm_private_dns_zone.private_dns_zones[count.index].name}-link"
  resource_group_name   = var.resourcegroup_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zones[count.index].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}