variable "resource_group_name" {
  description = "Назва групи ресурсів."
  type        = string
  default     = "az104-rg6"
}

variable "location" {
  description = "Регіон Azure для розгортання ресурсів."
  type        = string
  default     = "Poland Central"
}

variable "admin_username" {
  description = "Ім'я користувача адміністратора для VM."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Пароль адміністратора для VM. Має відповідати вимогам складності Azure."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Розмір віртуальних машин."
  type        = string
  default     = "Standard_B1s"
}
