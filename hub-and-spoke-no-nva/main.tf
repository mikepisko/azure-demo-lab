resource "random_string" "unique" {
  length  = 6
  upper   = false
  special = false
  lower   = true
}

resource "azurerm_resource_group" "vnet_rg" {
  name = var.resourcegroup_name_network
  location = var.location
  tags = var.tags
}

resource "azurerm_resource_group" "shared_services_rg" {
  name = var.resourcegroup_name_shared_services
  location = var.location
  tags = var.tags
}

resource "azurerm_resource_group" "dns_services_rg" {
  name = var.resourcegroup_name_dns_services
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name = var.vnet1_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags = var.tags
  address_space = var.vnet1_address_space
  location = var.location
}

# resource "azurerm_public_ip" "Bastion_PIP" {
#   name                = "AzureBastionPublicIP"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.vnet_rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "AzureBastion" {
#   depends_on = [azurerm_public_ip.Bastion_PIP,
#                 azurerm_subnet.vnet1_subnets_address_space["bastion_subnet"]
#                ]
#   name                = "LabBastionHost"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.vnet_rg.name
#
#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.vnet1_subnets_address_space["bastion_subnet"].id
#     public_ip_address_id = azurerm_public_ip.Bastion_PIP.id
#   }
# }

resource "azurerm_subnet" "vnet1_subnets_address_space" {
  for_each = var.vnet1_subnets
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  name = each.value["name"]
  address_prefixes = each.value["address_prefixes"]

   dynamic "delegation" {
    for_each = length(regexall("(inbound|outbound)", each.value["name"])) > 0 ? [each.value] : []
    
    content {
      name = "dnsResolversDelegation"

      service_delegation {
        name = "Microsoft.Network/dnsResolvers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}

resource "azurerm_virtual_network_dns_servers" "custom_dns_vnet1" {
  depends_on = [ azurerm_virtual_network.vnet1,
                 module.private-dns-resolver 
               ] 
  virtual_network_id = azurerm_virtual_network.vnet1.id
  dns_servers        = [module.private-dns-resolver.inbound_endpoint_private_ip]
  
}


resource "azurerm_virtual_network" "vnet2" {
  name = var.vnet2_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags = var.tags
  location = var.location
  address_space = var.vnet2_address_space
}

resource "azurerm_subnet" "vnet2_subnets_address_space" {
  for_each = var.vnet2_subnets
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  name = each.value["name"]
  address_prefixes = each.value["address_prefixes"]
}

resource "azurerm_virtual_network_dns_servers" "custom_dns_vnet2" {
  depends_on = [ azurerm_virtual_network.vnet2,
                 module.private-dns-resolver 
               ] 
  virtual_network_id = azurerm_virtual_network.vnet2.id
  dns_servers        = [module.private-dns-resolver.inbound_endpoint_private_ip]
  
}

resource "azurerm_virtual_network_peering" "vnet1-to-vnet2" {
  name                      = "${var.vnet1_name}-to-${var.vnet2_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "vnet2-to-vnet1" {
  name                      = "${var.vnet2_name}-to-${var.vnet1_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true 
}

module "storage-account" {
  depends_on = [
    azurerm_resource_group.shared_services_rg
  ]
  source = "../modules/storage-account"
  resourcegroup_name = azurerm_resource_group.shared_services_rg.name
  random_string       = random_string.unique.result
}
 module "private-dns-zone" {
   depends_on = [
     azurerm_resource_group.dns_services_rg,
     azurerm_virtual_network.vnet1,
   ]
   source = "../modules/dns/private-dns-zone"
   resourcegroup_name = azurerm_resource_group.dns_services_rg.name
   virtual_network_id = azurerm_virtual_network.vnet1.id
 }

module "private-dns-resolver" {
  depends_on = [
    azurerm_resource_group.dns_services_rg,
    azurerm_virtual_network.vnet1,
    azurerm_subnet.vnet1_subnets_address_space["subnet-inbound"],
    azurerm_subnet.vnet1_subnets_address_space["subnet-outbound"]
  ]
  source = "../modules/dns/private-dns-resolver"
  resourcegroup_name = azurerm_resource_group.dns_services_rg.name
  location = var.location
  virtual_network_id = azurerm_virtual_network.vnet1.id
  inbound_subnet_id    = local.inbound_outbound_subnets["subnet3"] # Subnet 3 (inbound)
  outbound_subnet_id   = local.inbound_outbound_subnets["subnet4"] # Subnet 4 (outbound)
}

  output "inbound_outbound_subnets_output" {
  value = local.inbound_outbound_subnets
  description = "The list of inbound and outbound subnets"
}