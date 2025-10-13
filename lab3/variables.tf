variable "rg_name" {
  description = "Name for the resource group."
  type        = string
  default     = "az104-rg3"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "Poland Central"
}

variable "disk5_name" {
  description = "Name for the 5th managed disk."
  type        = string
  default     = "az104-disk5"
}

variable "disk5_sku" {
  description = "SKU for the 5th managed disk."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "disk5_size_gb" {
  description = "Size in GB for the 5th managed disk."
  type        = number
  default     = 32
}
