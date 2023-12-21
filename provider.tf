terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.0.0"
      
    }
  }
}
# provider.tf

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Use the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "1-522d0b26-playground-sandbox"
}

resource "azurerm_storage_account" "storage" {
  name                     = "dataacc"
  resource_group_name      = data.azurerm_resource_group.existing_rg.name
  location                 = "eastus"  
  account_tier             = "Standard"
  account_replication_type = "LRS"


  network_rules {
    default_action             = "Allow"
    
    virtual_network_subnet_ids = []
  }

  identity {
    type = "SystemAssigned"
  }
}

