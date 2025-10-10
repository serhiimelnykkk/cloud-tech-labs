variable "internal_user_name" {
  description = "User principal name for the internal user."
  type        = string
  default     = "az104-user1"
}

variable "external_user_email" {
  description = "Email address for the external user invitation."
  type        = string
}

variable "external_user_display_name" {
  description = "Display name for the external user."
  type        = string
}

variable "group_name" {
  description = "The name of the security group."
  type        = string
  default     = "IT Lab Administrators"
}