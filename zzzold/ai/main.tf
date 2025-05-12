module "naming_openai" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "openai"
}

module "naming_search" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "search"
}

module "naming_pe_openai" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  suffix        = "openai"
  resource_type = "pe"
}

module "naming_pe_search" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  suffix        = "search"
  resource_type = "pe"
}

locals {
  resource_names = {
    openai  = module.naming_openai.resource_name
    search  = module.naming_search.resource_name
  }
}

resource "azurerm_cognitive_account" "openai" {
  name                = module.naming_openai.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = var.tags
  custom_subdomain_name = module.naming_openai.resource_name

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "gpt" {
  name                 = "gpt"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }

  scale {
    type     = "Standard"
    capacity = var.openai_capacity
  }
}

resource "azurerm_search_service" "main" {
  name                = module.naming_search.resource_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                = var.cognitive_search_sku
  tags               = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "openai" {
  name                = module.naming_pe_openai.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${module.naming_pe_openai.resource_name}-psc"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    is_manual_connection          = false
    subresource_names             = ["account"]
  }
}

resource "azurerm_private_endpoint" "search" {
  name                = module.naming_pe_search.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${module.naming_pe_search.resource_name}-psc"
    private_connection_resource_id = azurerm_search_service.main.id
    is_manual_connection          = false
    subresource_names             = ["searchService"]
  }
}

# Store secrets in Key Vault
resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "openai-endpoint"
  value        = azurerm_cognitive_account.openai.endpoint
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "openai_key" {
  name         = "openai-key"
  value        = azurerm_cognitive_account.openai.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "search_endpoint" {
  name         = "search-endpoint"
  value        = "https://${azurerm_search_service.main.name}.search.windows.net"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "search_key" {
  name         = "search-key"
  value        = azurerm_search_service.main.primary_key
  key_vault_id = var.key_vault_id
}
