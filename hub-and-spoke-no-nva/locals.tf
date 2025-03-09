#Finds the subnets that have inbound or outbound in their name and creates a map of the subnet names to their IDs
#This is used to pass the subnet IDs to the private DNS resolver module

locals {
  inbound_outbound_subnets = {
    for k, v in azurerm_subnet.vnet1_subnets_address_space :
    k => v.id if length(regexall("(inbound|outbound)", v.name)) > 0
  }
}