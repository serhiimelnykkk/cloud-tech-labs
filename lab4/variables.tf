variable "rg_name" {
  description = "Name for the resource group."
  type        = string
  default     = "az104-rg4"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "Poland Central"
}

variable "public_dns_zone_name" {
  description = "Name for the public DNS zone."
  type        = string
  default     = "contoso-sm12345.com"
}

variable "private_dns_zone_name" {
  description = "Name for the private DNS zone."
  type        = string
  default     = "private.contoso-sm12345.com"
}
