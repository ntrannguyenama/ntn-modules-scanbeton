module "naming_openai" {
  source = "../naming"

  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "openai"
}


module "naming_speech" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = null
  resource_type = "speech"
}

module "naming_search" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = null
  resource_type = "search"
}


resource "azurerm_cognitive_account" "openai" {
  name                = "scanbeton-dev-openai"
  location            = "westeurope"
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = var.tags
  custom_subdomain_name = "scanbeton-api-oai"

  dynamic_throttling_enabled = false
  fqdns = []

  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_cognitive_account" "speech_service" {
  name                = module.naming_speech.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic_throttling_enabled = false
  fqdns = []

  kind     = "SpeechServices"
  sku_name = "F0"

  tags = {
    environment = "dev"
    service     = "speech"
  }
}