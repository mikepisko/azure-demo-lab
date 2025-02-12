variable "resourcegroup_name" {
    type = string
    description = "The name of the resource group to create"
}

variable "random_string" {
    type = string
    description = "A random string to append to the storage account name"
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

variable "storage_account_tier" {
  description = "The performance tier of the storage account. Choose between 'Standard' or 'Premium'."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium", "FileStorage"], var.storage_account_tier)
    error_message = "The storage_account_tier must be 'Standard' or 'Premium' of FileStorage."
  }
}

variable "storage_account_replication_type" {
  description = "The type of replication to use for the storage account. Choose between 'LRS', 'GRS', 'RAGRS', 'ZRS', or 'GZRS'."
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS"], var.storage_account_replication_type)
    error_message = "The storage_account_replication_type must be 'LRS', 'GRS', 'RAGRS', 'ZRS', or 'GZRS'."
  }
}

variable "storage_account_kind" {
  description = "The type of storage account to create. Choose between 'StorageV2', 'StorageV2 (general purpose v2)', 'Storage', 'Storage (general purpose)', 'BlobStorage', 'FileStorage', or 'BlockBlobStorage'."
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["StorageV2", "StorageV2 (general purpose v2)", "Storage", "Storage (general purpose)", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.storage_account_kind)
    error_message = "The storage_account_kind must be 'StorageV2', 'StorageV2 (general purpose v2)', 'Storage', 'Storage (general purpose)', 'BlobStorage', 'FileStorage', or 'BlockBlobStorage'."
  }
}

variable "storage_account_base_name" {
  description = "The base name of the storage account to create"
  type        = string
  default     = "salab"
}

variable "storage_account_region" {
  description = "The region where the storage account will be created"
  type        = string
  default     = "eastus2"
}

variable "storage_access_tier" {
  description = "The access tier of the storage account. Choose between 'Hot' or 'Cool'."
  type        = string
  default     = "Hot"
  validation {
    condition     = contains(["Hot", "Cool"], var.storage_access_tier)
    error_message = "The storage_access_tier must be 'Hot' or 'Cool'."
  }
}

variable "public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the resource."
  type        = bool
  default     = false
}