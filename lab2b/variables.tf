variable "rg_name" {
  description = "Name for the resource group."
  type        = string
  default     = "az104-rg2"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "East US"
}

variable "enforce_tag_policy" {
  description = "Set to true to enable the 'Require a tag' policy assignment. Corresponds to Task 2."
  type        = bool
  default     = false
}

variable "apply_tag_policy" {
  description = "Set to true to enable the 'Inherit a tag' policy assignment. Corresponds to Task 3."
  type        = bool
  default     = false
}
