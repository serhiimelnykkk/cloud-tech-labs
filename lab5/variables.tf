variable "rg_name" {
  description = "Name for the resource group."
  type        = string
  default     = "az104-rg5"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "Poland Central"
}

variable "admin_username" {
  description = "Administrator username for the virtual machines."
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Administrator password for the virtual machines."
  type        = string
  sensitive   = true
}
