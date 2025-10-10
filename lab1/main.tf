terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azuread" {}
provider "time" {}

data "azuread_domains" "default" {}
data "azuread_client_config" "current" {}

resource "azuread_user" "internal_user" {
  user_principal_name = "${var.internal_user_name}@${data.azuread_domains.default.domains[0].domain_name}"
  display_name        = var.internal_user_name
  password            = "A-very-Strong-P@ssw0rd123!"
  account_enabled     = true
  job_title           = "IT Lab Administrator"
  department          = "IT"
  usage_location      = "US"
}

resource "azuread_invitation" "external_user" {
  user_email_address = var.external_user_email
  redirect_url       = "https://portal.azure.com"
  user_display_name  = var.external_user_display_name
}

resource "time_sleep" "wait_for_user_provisioning" {
  create_duration = "30s"
  depends_on      = [azuread_invitation.external_user]
}

data "azuread_user" "invited_user" {
  user_principal_name = "${replace(var.external_user_email, "@", "_")}#EXT#@${data.azuread_domains.default.domains[0].domain_name}"

  depends_on = [time_sleep.wait_for_user_provisioning]
}

resource "azuread_group" "lab_admins" {
  display_name     = var.group_name
  description      = "Administrators that manage the IT lab"
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "internal_user_member" {
  group_object_id  = azuread_group.lab_admins.id
  member_object_id = azuread_user.internal_user.id
}

resource "azuread_group_member" "external_user_member" {
  group_object_id  = azuread_group.lab_admins.id
  member_object_id = data.azuread_user.invited_user.id
}