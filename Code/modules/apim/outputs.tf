output "api_managment_id" {
    value = azurerm_api_management.this.id
    description = "Deployed instance ID"
}

output "public_ip_addresses" {
    value = azurerm_api_management.this.public_ip_addresses
    description = "Public IP Addresses of the API Management Service"
}

output "principal_id" {
    value = azurerm_api_management.this.identity[0].principal_id
    description = "Principal ID of API Management Managed System Identity"
}

output "name" {
    value = azurerm_api_management.this.name
    description = "Name of the created API Managmenet instance"
}

