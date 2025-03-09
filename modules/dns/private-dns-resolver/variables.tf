variable "resolver_name" {
  description = "The name of the Private DNS Resolver"
  type        = string
  default = "dsnresolveruse2"
}

variable "inbound_endpoint_name" {
  description = "The name of the inbound endpoint"
  type        = string
  default = "inboundendpointuse2"
}

variable "inbound_endpoint_subnetId" {
  description = "The ID of the subnet to use for the inbound endpoint"
  type        = string
}

variable "outbound_endpoint_name" {
  description = "The name of the outbound endpoint"
  type        = string
  default     = "outboundendpointuse2"
}

variable "outbound_endpoint_subnetId" {
  description = "The ID of the subnet to use for the outbound endpoint"
  type        = string
}

variable "resourcegroup_name" {
  description = "The name of the resource group to create"
  type        = string
}

variable "location" {
  description = "The location/region where the resource group will be created"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to link to the private DNS zone"
  type        = string
}