variable "prefix" {
  default = "az104-"
  type    = string
}

variable "location" {
  default = "Norway East"
  type    = string
}

variable "admin_password" {
  default   = "Secretpassword123$"
  type      = string
  sensitive = true
}
