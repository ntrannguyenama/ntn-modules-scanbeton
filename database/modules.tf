locals {
  resource_types = {
    sql_server   = "sql"
    sql_database = "sqldb"
    sql_pe       = "sqlpe"
  }

  server_name   = module.naming_sql.resource_name
  database_name = module.naming_sqldb.resource_name
  pe_name      = module.naming_sql_pe.resource_name
}

module "naming_sql" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "sql"
}

module "naming_sqldb" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "sqldb"
}

module "naming_sql_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "sqlpe"
}