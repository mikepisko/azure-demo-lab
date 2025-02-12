# Configure AzureRM providers
terraform {
  required_providers {
    
    azurerm = {
      source  = "hashicorp/azurerm"
    }

    random = {
      source  = "hashicorp/random"
    }
  }
}
