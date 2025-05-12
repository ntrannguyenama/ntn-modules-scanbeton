locals {
  cluster_name = module.naming_adx.resource_name
  
  # Base tags that should be present on all resources
  base_tags = {
    Environment = var.environment
    Application = var.app_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
  
  # Merge base tags with provided tags, allowing overrides
  tags = merge(local.base_tags, var.tags)
}

# Create Data Explorer Cluster
resource "azurerm_kusto_cluster" "main" {
  name                = local.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Dev(No SLA)_Standard_E2a_v4"
    capacity = 1
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  auto_stop_enabled = true
  streaming_ingestion_enabled = true
}

# Create Public IPs for Data Explorer
resource "azurerm_public_ip" "adx_engine" {
  name                = "${module.naming_adxip_engine.resource_name}-engine"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                = "Standard"
  
  tags = local.tags
}

resource "azurerm_public_ip" "adx_data" {
  name                = "${module.naming_adxip_data.resource_name}-data"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                = "Standard"
  
  tags = local.tags
}

# Create Databases
resource "azurerm_kusto_database" "databases" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = azurerm_kusto_cluster.main.name
  hot_cache_period    = each.value.hot_cache_period
  soft_delete_period  = each.value.soft_delete_period
}

# Store cluster information in Key Vault
resource "azurerm_key_vault_secret" "adx_uri" {
  name         = "adx-uri"
  value        = "https://${azurerm_kusto_cluster.main.uri}"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "adx_name" {
  name         = "adx-name"
  value        = azurerm_kusto_cluster.main.name
  key_vault_id = var.key_vault_id
}

data "azurerm_client_config" "current" {}

module "naming_adx" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adx"
}

module "naming_adxip_engine" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adxip"
}

module "naming_adxip_data" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adxip"
}

module "naming_adx_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adxpe"
}

resource "azurerm_private_endpoint" "adx" {
  name                = "${var.app_name}-${var.environment}-adxpe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.app_name}-${var.environment}-adxpe-connection"
    private_connection_resource_id = azurerm_kusto_cluster.main.id
    is_manual_connection           = false
    subresource_names             = ["cluster"]
  }

  tags = var.tags
}
