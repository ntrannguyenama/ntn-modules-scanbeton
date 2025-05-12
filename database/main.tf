resource "azurerm_mssql_server" "main" {
  name                         = local.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = local.version
  administrator_login          = local.administrator_login
  administrator_login_password = "7*6Z9Y<VgAzX"
  minimum_tls_version         = local.minimum_tls_version

  public_network_access_enabled = local.public_network_access_enabled
  outbound_network_restriction_enabled = local.outbound_network_restriction_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_mssql_database" "main" {
  name                = "main"
  server_id           = azurerm_mssql_server.main.id
  sku_name            = local.sku_name
  max_size_gb         = local.max_size_gb
  geo_backup_enabled  = local.geo_backup_enabled

  tags = local.tags
}

resource "azurerm_private_endpoint" "sql" {
  name                = local.pe_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.pe_name}-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection          = false
    subresource_names            = ["sqlServer"]
  }

  tags = local.tags
}
