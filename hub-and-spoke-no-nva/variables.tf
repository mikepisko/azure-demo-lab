variable "resourcegroup_name_network" {
    type = string
    description = "The name of the resource group to create"
    default = "rg-lab-vnet-use2"
}

variable "resourcegroup_name_shared_services" {
    type = string
    description = "The name of the resource group to create"
    default = "rg-lab-shared-services-use2"
}

variable "resourcegroup_name_dns_services" {
    type = string
    description = "The name of the resource group to create"
    default = "rg-lab-dns-services-use2"
}

variable "location" {
    type = string
    description = "The location/region where the resource group will be created"
    default = "eastus2"
}

variable "tags" {
    type = map(string)
    description = "A map of tags to assign to the resource group"
    default = {
        Environment = "Lab"
        Owner = "Michael Piskorski"
    }
}

variable "vnet1_name" {
    type = string
    description = "The name of the virtual network to create"
    default = "vnet-10.0.0.0_24-lab-hub-use2"
}

variable "vnet1_address_space" {
    type = list(string)
    description = "The address space that is used by the virtual network"
    default = ["10.0.0.0/23"]
}

variable "vnet1_subnets" {
    type = map(any)
    description = "The name of the subnet to create"
    default = {
        subnet1 = {
            name = "subnet-10.0.0.64_26-pe-subnet-lab-use2"
            address_prefixes = ["10.0.0.64/26"]}
        subnet2 = {
            name = "subnet-10.0.0.128_26-vm-subnet-lab-use2"
            address_prefixes = ["10.0.0.128/26"]}
        # The name of the subnet mut be AzureBastionSubnet
        bastion_subnet = {
            name = "AzureBastionSubnet"
            address_prefixes = ["10.0.0.0/26"]}
            }
}

variable "vnet2_name" {
    type = string
    description = "The name of the virtual network to create"
    default = "vnet-10.1.0.0_23-lab-spoke-use2"
}

variable "vnet2_address_space" {
    type = list(string)
    description = "The address space that is used by the virtual network"
    default = ["10.1.0.0/23"]
}

variable "vnet2_subnets" {
    type = map(any)
    description = "The name of the subnet to create"
    default = {
        subnet1 = {
            name = "subnet-10.1.0.0_26-pe-subnet-lab-spoke-use2"
            address_prefixes = ["10.1.0.0/26"]}
        subnet2 = {
            name = "subnet-10.1.0.64_26-vm-subnet-lab-spoke-use2"
            address_prefixes = ["10.1.0.64/26"]}
            }
}