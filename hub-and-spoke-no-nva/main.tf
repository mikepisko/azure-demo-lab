provider "azurerm" {
  features {}
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

resource "azurerm_virtual_network" "vnet1" {
  name = var.vnet1_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags = var.tags
  address_space = var.vnet1_address_space
  location = var.location
}

resource "azurerm_public_ip" "Bastion_PIP" {
  name                = "AzureBastionPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "AzureBastion" {
  name                = "LabBastionHost"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.vnet1_subnets_address_space["bastion_subnet"].id
    public_ip_address_id = azurerm_public_ip.Bastion_PIP.id
  }
}

resource "azurerm_subnet" "vnet1_subnets_address_space" {
  for_each = var.vnet1_subnets
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  name = each.value["name"]
  address_prefixes = each.value["address_prefixes"]
}

resource "azurerm_virtual_network" "vnet2" {
  name = var.vnet2_name
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags = var.tags
  location = var.location
  address_space = var.vnet2_address_space
}

resource "azurerm_subnet" "vnet2_subnet1_address_space" {
  for_each = var.vnet2_subnets
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  name = each.value["name"]
  address_prefixes = each.value["address_prefixes"]
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
