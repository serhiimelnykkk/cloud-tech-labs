terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg3" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_managed_disk" "disk1" {
  name                 = "az104-disk1"
  location             = azurerm_resource_group.rg3.location
  resource_group_name  = azurerm_resource_group.rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_managed_disk" "disk2" {
  name                 = "az104-disk2"
  location             = azurerm_resource_group.rg3.location
  resource_group_name  = azurerm_resource_group.rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_managed_disk" "disk3" {
  name                 = "az104-disk3"
  location             = azurerm_resource_group.rg3.location
  resource_group_name  = azurerm_resource_group.rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_managed_disk" "disk4" {
  name                 = "az104-disk4"
  location             = azurerm_resource_group.rg3.location
  resource_group_name  = azurerm_resource_group.rg3.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

resource "azurerm_managed_disk" "disk5" {
  name                 = var.disk5_name
  location             = azurerm_resource_group.rg3.location
  resource_group_name  = azurerm_resource_group.rg3.name
  storage_account_type = var.disk5_sku
  create_option        = "Empty"
  disk_size_gb         = var.disk5_size_gb
}


