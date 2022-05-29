resource "random_string" "this" {
  length  = 5
  upper   = false
  lower   = true
  special = false
}


#### vnet ####

module "data_product_1_vnet" {
  source          = "../../modules/vnet"
  rg_name         = var.rg_name
  location        = var.location
  name            = "vnet"
  prefix          = "data-product-1"
  address_space   = ["10.1.0.0/16"]
  subnet_prefixes = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  subnet_names    = ["api_management", "dp1", "dp2"]

  subnet_enforce_private_link_endpoint_network_policies = {
    dp1 = true
    dp2 = true
  }
}


#### API Management ####
module "api_management" {
  source = "../../modules/apim"
  rg_name = var.rg_name
  location = var.location
  name = "innomesh-apim"
  publisher_name = "Person Person"
  publisher_email = "test@test.nl"  
  subnet_id = lookup(module.data_product_1_vnet.subnets_name_id, "api_management")
}


#### API to access storage container from apim ####

resource "azurerm_api_management_api" "dp1_api" {
  name                = "example-api"
  resource_group_name = var.rg_name
  api_management_name = module.api_management.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "openapi+json"
    content_value  = file("dp1_api.json")  
  }

  depends_on = [
    module.api_management
  ]
}


#### Policy for api to access storage container ####

resource "azurerm_api_management_api_policy" "dp1_policy" {
  api_name            = azurerm_api_management_api.dp1_api.name
  api_management_name = module.api_management.name
  resource_group_name = var.rg_name
  xml_content = file("dp1_policy.xml")

  depends_on = [
    module.api_management,
    azurerm_api_management_api.dp1_api
  ]
}


#### Private DNS zone for storage container ####

module "private_dns_zone_st_blob" {
  source                = "../../modules/private_dns_zone"
  rg_name               = var.rg_name
  private_dns_zone_name = "privatelink.blob.azure.net"
  vnet_id               = module.data_product_1_vnet.id
}


##### Storage Account ####

module "my_st" {
  source                 = "../../modules/storage_account" 
  name                   = "st"
  prefix                 = "agg3"
  rg_name                = var.rg_name
  location               = var.location
  network_default_action = "Allow"

  pe_subnet_id = lookup(module.data_product_1_vnet.subnets_name_id, "dp1")
  pe_subresource_dns_zone_id = {
    blob = module.private_dns_zone_st_blob.id
  }
}


#### APIM Role assignment

resource "azurerm_role_assignment" "apim_to_storage" {
  scope                = module.my_st.id
  principal_id         = module.api_management.principal_id
  role_definition_name = "Storage Blob Data Owner"

  depends_on = [
    module.my_st, 
    module.api_management
  ]
}


#### Mssql Server ####

resource "azurerm_mssql_server" "mysql" {
  name                          = "mysql-dp2"
  resource_group_name           = var.rg_name
  location                      = var.location
  administrator_login           = "sqladmin"
  administrator_login_password  = "Justfortesting1!"
  minimum_tls_version           = "1.2"
  version                       = "12.0"
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }
}


#### SQL Server Private Endpoint ####

resource "azurerm_private_endpoint" "pe_sql_server" {
  name                = "${azurerm_mssql_server.mysql.name}-pe-${random_string.this.result}"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = lookup(module.data_product_1_vnet.subnets_name_id, "dp2")

  private_service_connection {
    name                           = "${azurerm_mssql_server.mysql.name}-connection-${random_string.this.result}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mysql.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "mssql_database_zone_group"
    private_dns_zone_ids = [module.private_dns_zone_mssql_server.id]
  }

  timeouts {
    create = "5m"
    delete = "5m"
  }
}


### SQL Server DNS Zone  ####

module "private_dns_zone_mssql_server" {
  source                = "../../modules/private_dns_zone"
  rg_name               = var.rg_name
  private_dns_zone_name = "privatelink.database.azure.net"
  vnet_id               = module.data_product_1_vnet.id
}


#### SQL Database ####

resource "azurerm_mssql_database" "mssql_database" {
  name                        = "dp2"
  max_size_gb                 = 10
  server_id                   = azurerm_mssql_server.mysql.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS" # ! don't you dare to change it

  depends_on = [
    azurerm_mssql_server.mysql
  ]
}


#### Azure Data Factory ####

resource "azurerm_data_factory" "this" {
  name                            = "adf-innomesh"
  location                        = var.location
  resource_group_name             = var.rg_name
  managed_virtual_network_enabled = true
  public_network_enabled          = false

  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


#### Private Endpoints Azure Data Factory ####

# PE adf to mssql #
resource "azurerm_data_factory_managed_private_endpoint" "pe_mssql_server" {
  name               = "pe-adf-dp1"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = azurerm_mssql_server.mysql.id
  subresource_name = "sqlServer"
  timeouts {
    create = "5m"
    delete = "5m"
  }
}

# PE adf to sa #
resource "azurerm_data_factory_managed_private_endpoint" "pe_storage_account" {
  name               = "pe-adf-dp2"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = module.my_st.id
  subresource_name = "blob"
  timeouts {
    create = "5m"
    delete = "5m"
  }
}

