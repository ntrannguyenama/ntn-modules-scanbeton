module "naming_storage" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  resource_type = "sa"
}

module "naming_storage_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "stpe"
}

module "naming_cdn" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "cdn"
}

module "naming_cdn_endpoint" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "cdn"
}

locals {
  base_tags = {
    Environment = var.environment
    Application = var.app_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }

  tags = merge(local.base_tags, var.tags)
}

resource "azurerm_storage_account" "web" {
  name                            = lower(module.naming_storage.storage_name)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = local.account_tier
  account_replication_type        = local.account_replication_type
  account_kind                    = local.account_kind
  https_traffic_only_enabled      = local.https_traffic_only_enabled
  min_tls_version                = local.min_tls_version
  allow_nested_items_to_be_public = local.allow_nested_items_to_be_public

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.tags
}

resource "azurerm_storage_account" "sql" {
  name                            = "${lower(module.naming_storage.storage_name)}sqlbackup"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = local.account_tier
  account_replication_type        = local.account_replication_type
  account_kind                    = local.account_kind
  https_traffic_only_enabled      = local.https_traffic_only_enabled
  min_tls_version                = local.min_tls_version
  allow_nested_items_to_be_public = local.allow_nested_items_to_be_public

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "web" {
  storage_account_id = azurerm_storage_account.web.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_private_endpoint" "storage" {
  name                = module.naming_storage_pe.storageendpoint_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id          = var.subnet_id

  private_service_connection {
    name                           = "${var.app_name}-${var.environment}-stpsc"
    private_connection_resource_id = azurerm_storage_account.web.id
    is_manual_connection          = false
    subresource_names            = ["web"]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "sql_storage" {
  name                = "${module.naming_storage_pe.storageendpoint_name}-sql"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.app_name}-${var.environment}-sql-stpsc"
    private_connection_resource_id = azurerm_storage_account.sql.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags
}

module "naming_pe" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  resource_type = "stpe"
}
/*
resource "azurerm_cdn_profile" "main" {
  name                = module.naming_cdn.resource_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                = "Standard_Microsoft"

  tags = var.tags
}

resource "azurerm_cdn_endpoint" "main" {
  name                = "${module.naming_cdn.resource_name}-ep"
  profile_name        = azurerm_cdn_profile.main.name
  resource_group_name = var.resource_group_name
  location            = var.location

  origin {
    name       = "${var.app_name}-${var.environment}-origin"
    host_name  = azurerm_storage_account.web.primary_web_host
  }

  tags = var.tags
}
*/