variable "resourcegroup_name" {
  description = "The name of the resource group to create"
  type        = string
}

variable "private_dns_zone_names" {
  type    = list(string)
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.vaultcore.azure.net"
  ]
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to link to the private DNS zone"
  type        = string
}