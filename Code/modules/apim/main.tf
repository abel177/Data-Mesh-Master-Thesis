resource "azurerm_api_management" "this" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.location
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Developer_1"

  virtual_network_type = "External"
  
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}


#note: inbound port 3443 needs to be open in the subnet when it is placed internal
# https://medium.com/marcus-tee-anytime/secure-azure-blob-storage-with-azure-api-management-managed-identities-b0b82b53533c


