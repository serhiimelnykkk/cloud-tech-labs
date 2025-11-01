terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "ea338396-ce5c-42ca-8ed1-bb1a082d24ef"
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "random_string" "sa_name" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                          = random_string.sa_name.result
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_replication_type      = "LRS"
  account_tier                  = "Standard"
  public_network_access_enabled = true
}

resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id         = azurerm_storage_account.sa.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
}

resource "azurerm_storage_management_policy" "storage_rules" {
  storage_account_id = azurerm_storage_account.sa.id

  rule {
    name    = "Movetocool"
    enabled = true
    actions {
      base_blob {
        tier_to_cool_after_days_since_creation_greater_than = 30
      }
    }
    filters {
      blob_types = ["blockBlob"]
    }
  }
}

resource "azurerm_storage_container" "container" {
  name                 = "data"
  storage_account_name = azurerm_storage_account.sa.name

  depends_on = [azurerm_storage_account_network_rules.network_rules]
}

resource "azurerm_storage_container_immutability_policy" "immutability_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.container.resource_manager_id
  immutability_period_in_days           = 180

  depends_on = [azurerm_storage_blob.blob]
}

resource "azurerm_storage_blob" "blob" {
  name                   = "securitytest/sample.txt"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  access_tier            = "Hot"
  source                 = "sample.txt"
}

resource "time_offset" "start" {
  offset_days = -1
}

resource "time_offset" "expiry" {
  offset_days = 1
}

data "azurerm_storage_account_blob_container_sas" "sas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  container_name    = azurerm_storage_container.container.name

  start  = time_offset.start.rfc3339
  expiry = time_offset.expiry.rfc3339

  permissions {
    read   = true
    write  = false
    list   = false
    add    = false
    delete = false
    create = false
  }
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "share1"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 1
  access_tier          = "TransactionOptimized"

  depends_on = [
    azurerm_storage_account_network_rules.network_rules
  ]

}

resource "azurerm_storage_share_file" "share_file" {
  name             = "uploaded-file.txt"
  storage_share_id = azurerm_storage_share.fileshare.id
  source           = "sample.txt"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}
