resource "azurerm_private_dns_resolver" "dnsresolver" {
  name                = var.resolver_name
  resource_group_name = var.resourcegroup_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint" {
  name                    = var.inbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.dnsresolver.id
  location                = azurerm_private_dns_resolver.dnsresolver.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.inbound_subnet_id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound_endpoint" {
  name                    = var.outbound_endpoint_name
  private_dns_resolver_id = azurerm_private_dns_resolver.dnsresolver.id
  location                = azurerm_private_dns_resolver.dnsresolver.location
  subnet_id               = var.outbound_subnet_id
}