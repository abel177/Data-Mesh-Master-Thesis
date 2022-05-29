resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.name}"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg_name
  dns_servers         = var.dns_servers

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "this" {
  count                                          = length(var.subnet_names)
  name                                           = var.subnet_names[count.index]
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [var.subnet_prefixes[count.index]]
  service_endpoints                              = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)
  enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, var.subnet_names[count.index], false)
  enforce_private_link_service_network_policies  = lookup(var.subnet_enforce_private_link_service_network_policies, var.subnet_names[count.index], false)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], {})
    content {
      name = delegation.key
      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = var.nsg_ids
  subnet_id                 = local.azurerm_subnets[each.key]
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each       = var.route_tables_ids
  route_table_id = each.value
  subnet_id      = local.azurerm_subnets[each.key]
}
