output "load_balancer_public_ip" {
  description = "Публічна IP-адреса Azure Load Balancer."
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "application_gateway_public_ip" {
  description = "Публічна IP-адреса Azure Application Gateway."
  value       = azurerm_public_ip.appgw_pip.ip_address
}
