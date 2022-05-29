resource "random_string" "this" {
  length  = 5
  upper   = false
  lower   = true
  special = false
}

resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${random_string.this.result}_link_api"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.vnet_id

  depends_on = [
    azurerm_private_dns_zone.this
  ]
}
