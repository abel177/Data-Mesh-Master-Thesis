resource "random_string" "this" {
  length  = 3
  upper   = false
  lower   = true
  special = false
}

resource "azurerm_storage_account" "this" {
  name                      = "${replace(var.prefix, "-", "")}${var.name}${random_string.this.result}"
  resource_group_name       = var.rg_name
  location                  = var.location
  account_tier              = var.account_tier
  account_kind              = var.account_kind
  account_replication_type  = var.account_replication_type
  min_tls_version           = "TLS1_2"
  is_hns_enabled            = var.datalake_v2
  enable_https_traffic_only = true
  allow_blob_public_access  = false

  network_rules {
    default_action             = var.network_default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.subnet_ids
    bypass                     = var.bypass
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "this" {
  count               = length(var.pe_subresource_dns_zone_id)
  name                = "${azurerm_storage_account.this.name}-pe-${keys(var.pe_subresource_dns_zone_id)[count.index]}-${random_string.this.result}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id


  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-connection-${random_string.this.result}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = [keys(var.pe_subresource_dns_zone_id)[count.index]]
  }

  private_dns_zone_group {
    name                 = "st_${keys(var.pe_subresource_dns_zone_id)[count.index]}_zone_group"
    private_dns_zone_ids = [values(var.pe_subresource_dns_zone_id)[count.index]]
  }

  lifecycle {
    ignore_changes = [tags]
  }

  timeouts {
    create = "5m"
    delete = "5m"
  }
}
