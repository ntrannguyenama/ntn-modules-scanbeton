locals {
  location = var.location
  tags = merge(var.tags, {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "Terraform"
  })
  frontend_url = "https://${var.app_name}-${var.environment}.azurewebsites.net"
}

module "naming_app_service" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = null
  resource_type = "app"
}

module "naming_app_service_plan" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = null
  resource_type = "appsp"
}

module "resource_group" {
  source = "../resource-group"

  app_name    = var.app_name
  environment = var.environment
  location    = local.location
  tags        = local.tags
}

module "network" {
  source = "../network"

  app_name            = var.app_name
  environment         = var.environment
  location            = local.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
  address_space       = var.address_space
  subnets            = var.subnets
  dns_zone = var.dns_zone
}

module "storage" {
  source = "../storage"

  app_name            = var.app_name
  environment         = var.environment
  location            = local.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.network.subnet_ids["frontend"]
  tags                = local.tags
  storage_account = var.storage_account
}

module "key_vault" {
  source = "../key-vault"

  app_name                = var.app_name
  environment             = var.environment
  location               = var.location
  resource_group_name    = module.resource_group.name
  admin_object_ids       = var.key_vault_admin_ids
  subnet_id              = module.network.subnet_ids["backend"]
  create_private_endpoint = true
  tenant_id              = data.azurerm_client_config.current.tenant_id
  object_id              = data.azurerm_client_config.current.object_id
  key_vault = var.key_vault
  tags = local.tags
}

module "service_plan" {
  source = "../service-plan"

  for_each = {
    for service_plan in var.service_plan : "${module.naming_app_service_plan.resource_name}${service_plan.suffix}" => service_plan
  }

  name = each.key
  service_plan = each.value
  resource_group_name = module.resource_group.name
  location           = local.location
  app_name           = var.app_name
  environment        = var.environment
}


module "app_service" {
  source = "../app-service"

  for_each = {
    for web_app in var.web_app : "${module.naming_app_service.resource_name}${web_app.suffix}" => web_app
  }

  name = each.key
  resource_group_name = module.resource_group.name
  location           = local.location
  app_name           = var.app_name
  environment        = var.environment
  backend_subnet_id  = module.network.subnet_ids["backend"]
  key_vault_id       = module.key_vault.id
  key_vault_url      = module.key_vault.uri
  frontend_url       = local.frontend_url
  web_app            = each.value
  tags               = local.tags
  service_plan_id = module.service_plan[each.value.service_plan_key].app_service_plan_id
}

resource "random_string" "sql_admin_username" {
  length  = 16
  special = false
}

resource "random_password" "sql_admin_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "database" {
  source = "../database"

  app_name                      = var.app_name
  environment                   = var.environment
  location                      = local.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.network.subnet_ids["backend"]
  administrator_login           = random_string.sql_admin_username.result
  administrator_login_password  = random_password.sql_admin_password.result
  sql = var.sql
  tags                         = local.tags
}

module "ai" {
  source = "../ai"

  app_name                      = var.app_name
  environment                   = var.environment
  location                      = local.location
  resource_group_name           = module.resource_group.name
  tags                         = local.tags
}
/*
module "iot" {
  count = var.enable_iot ? 1 : 0

  source = "../iot"

  app_name                  = var.app_name
  environment               = var.environment
  location                  = local.location
  resource_group_name       = module.resource_group.name
  storage_connection_string = module.storage.connection_string
  subnet_id                = module.network.subnet_ids["backend"]
  tags                     = local.tags
}

module "data_explorer" {
  source = "../data-explorer"
  count  = var.enable_adx ? 1 : 0

  app_name            = var.app_name
  environment         = var.environment
  location            = local.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.network.subnet_ids["backend"]
  key_vault_id        = module.key_vault.id
  tags                = local.tags
}

module "ai" {
  source = "../ai"
  count  = var.enable_ai ? 1 : 0

  app_name            = var.app_name
  environment         = var.environment
  name                = "${var.app_name}-${var.environment}"
  naming = {
    app_name      = var.app_name
    environment   = var.environment
    suffix        = null
    resource_type = "ai"
  }
  resource_group_name = module.resource_group.name
  location           = var.location
  subnet_id          = module.network.subnet_ids["backend"]
  key_vault_id       = module.key_vault.key_vault_id
  tags               = local.tags
}
*/

data "azurerm_client_config" "current" {}

