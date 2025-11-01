output "blob_sas_url" {
  value     = "${azurerm_storage_blob.blob.url}${data.azurerm_storage_account_blob_container_sas.sas.sas}"
  sensitive = true
}
