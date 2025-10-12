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
}

resource "azurerm_resource_group" "rg2" {
  name     = var.rg_name
  location = var.location

  tags = {
    "Cost Center" = "000"
  }
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag and its value on resources"
}

resource "azurerm_resource_group_policy_assignment" "enforce_tag" {
  count = var.enforce_tag_policy ? 1 : 0

  name                 = "Require-Cost-Center-Tag"
  resource_group_id    = azurerm_resource_group.rg2.id
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  description          = "Require Cost Center tag and its value on all resources in the resource group"

  parameters = jsonencode({
    "tagName" : {
      value = "Cost Center"
    },
    "tagValue" : {
      value = "000"
    }
  })
}

data "azurerm_policy_definition" "inherit_tag" {
  display_name = "Inherit a tag from the resource group if missing"
}

resource "azurerm_resource_group_policy_assignment" "apply_tag" {
  count = var.apply_tag_policy ? 1 : 0

  name                 = "Inherit-Cost-Center-Tag"
  resource_group_id    = azurerm_resource_group.rg2.id
  policy_definition_id = data.azurerm_policy_definition.inherit_tag.id
  description          = "Inherit the Cost Center tag and its value 000 from the resource group if missing"
  location             = var.location

  parameters = jsonencode({
    "tagName" : {
      value = "Cost Center"
    }
  })

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_management_lock" "rg_lock" {
  name       = "rg-lock"
  scope      = azurerm_resource_group.rg2.id
  lock_level = "CanNotDelete"
  notes      = "Lock to prevent accidental deletion of the resource group."
}
