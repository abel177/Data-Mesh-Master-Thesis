output "id" {
  description = "The id of the newly created vNet."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The Name of the newly created vNet."
  value       = azurerm_virtual_network.this.name
}

output "location" {
  description = "The location of the newly created vNet."
  value       = azurerm_virtual_network.this.location
}

output "address_space" {
  description = "The address space of the newly created vNet."
  value       = azurerm_virtual_network.this.address_space
}

output "subnets" {
  description = "The ids of subnets created inside the new vNet."
  value       = azurerm_subnet.this.*.id
}

output "subnets_name_id" {
  description = "Can be queried subnet-id by subnet name by using lookup(module.vnet.vnet_subnets_name_id, subnet1)."
  value       = local.azurerm_subnets
}
