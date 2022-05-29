output "name" {
  value       = azurerm_storage_account.this.name
  description = "Storage Account name"
}

output "id" {
  value       = azurerm_storage_account.this.id
  description = "Storage Account ID"
}

output "primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "Storage Account primary_access_key"
  sensitive   = true
}

output "primary_connection_str" {
  value       = azurerm_storage_account.this.primary_connection_string
  description = "Storage Account connection string"
  sensitive   = true
}
output "primary_blob_endpoint" {
  value       = azurerm_storage_account.this.primary_blob_endpoint
  description = "Storage Account connection string"
  sensitive   = true
}