output "inbound_endpoint_private_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations[0].private_ip_address
  description = "The private IP address assigned to the inbound DNS resolver endpoint"
}