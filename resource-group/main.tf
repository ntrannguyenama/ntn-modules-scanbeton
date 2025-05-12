module "naming_rg" {
  source       = "../naming"
  app_name     = var.app_name
  environment  = var.environment
  suffix       = var.suffix
  resource_type = "rg"
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

resource "azurerm_resource_group" "main" {
  name     = module.naming_rg.resource_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "resource-group-level" {
  count      = var.lock_level != null ? 1 : 0
  name       = "${module.naming_rg.resource_name}-lock"
  scope      = azurerm_resource_group.main.id
  lock_level = var.lock_level
  notes      = "Resource group ${azurerm_resource_group.main.name} is locked with ${var.lock_level} level."
}
