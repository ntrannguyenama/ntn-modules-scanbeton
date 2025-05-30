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