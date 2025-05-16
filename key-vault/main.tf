module "naming_key_vault" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "kv"
}

module "naming_key_vault_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "kvpe"
}

locals {
  key_vault_name = module.naming_key_vault.resource_name
  pe_name       = module.naming_key_vault_pe.resource_name
  
  base_tags = {
    Environment = var.environment
    Application = var.app_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
  
  tags = merge(local.base_tags, var.tags)

  name = "${var.app_name}-${var.environment}"
}

resource "random_password" "app_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = local.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id          = data.azurerm_client_config.current.tenant_id
  sku_name           = local.sku_name

  purge_protection_enabled = false
  soft_delete_retention_days = 90

  dynamic "access_policy" {
    for_each = toset(distinct(concat([data.azurerm_client_config.current.object_id], values(var.admin_object_ids))))
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      certificate_permissions = [
        "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
      ]

      key_permissions = [
        "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
      ]

      secret_permissions = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
    }
  }
  tags = local.tags
}

resource "azurerm_private_endpoint" "key_vault" {
  count = var.create_private_endpoint ? 1 : 0

  name                = local.pe_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.name}-kvpsc"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection          = false
    subresource_names             = ["vault"]
  }

  tags = local.tags
}

module "secret" {
  source = "../secret"

  for_each = {
    for secret in local.secret : "${secret.name}" => secret
  }

  secret = each.value

  app_name    = var.app_name
  environment = var.environment

  key_vault = azurerm_key_vault.main
}

