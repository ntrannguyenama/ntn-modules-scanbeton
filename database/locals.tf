locals {
    version = var.sql.version != null ? var.sql.version : "12.0"
    administrator_login = var.sql.administrator_login != null ? var.sql.administrator_login : "sqladmin"
    minimum_tls_version = var.sql.minimum_tls_version != null ? var.sql.minimum_tls_version : "1.2"
    public_network_access_enabled = var.sql.public_network_access_enabled != null ? var.sql.public_network_access_enabled : true
    outbound_network_restriction_enabled = var.sql.outbound_network_restriction_enabled != null ? var.sql.outbound_network_restriction_enabled : false

    sku_name = var.sql.sku_name != null ? var.sql.sku_name : "GP_Gen5_2"
    max_size_gb = var.sql.max_size_gb != null ? var.sql.max_size_gb : 16
    geo_backup_enabled = var.sql.geo_backup_enabled != null ? var.sql.geo_backup_enabled : true

    base_tags = {
        Environment = var.environment
        Application = var.app_name
        Terraform   = "true"
        ManagedBy   = "terraform"
    }
  
    tags = merge(local.base_tags, var.tags)
}

resource "random_password" "sql_admin" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_azuread_administrator" "admazbenzekkour" {
  # Identifiant de l'annuaire Azure Active Directory
  tenant_id = "4a3d9983-e936-4837-9552-9d9126a92eb0"

  # Définition de l'utilisateur administrateur
  login_username = "admaz.m.benzekkour@bouyguesconstruction.onmicrosoft.com"
  object_id      = "beff5bb0-ca88-446e-8e6f-56e08c2071ec"

  # Cette configuration détermine si l'authentification est seulement basée sur Azure AD
  azuread_authentication_only = false
}