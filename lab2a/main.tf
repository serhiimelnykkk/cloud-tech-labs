terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azurerm_management_group" "mg1" {
  name = var.mg_name

  display_name = var.mg_name
}

resource "azuread_group" "helpdesk" {
  display_name     = "Help Desk Group"
  security_enabled = true
}

data "azurerm_role_definition" "vm_contributor" {
  name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "helpdesk_vm_contributor" {
  scope = azurerm_management_group.mg1.id

  role_definition_id = data.azurerm_role_definition.vm_contributor.id

  principal_id = azuread_group.helpdesk.object_id
}


data "azurerm_role_definition" "support_request_contributor" {
  name = "Support Request Contributor"
}

resource "azurerm_role_definition" "custom_support_request" {
  name        = "Custom Support Request"
  description = "A custom contributor role for support requests."

  scope = azurerm_management_group.mg1.id

  permissions {
    actions = data.azurerm_role_definition.support_request_contributor.permissions[0].actions

    not_actions = [
      "Microsoft.Support/register/action"
    ]
  }
}
