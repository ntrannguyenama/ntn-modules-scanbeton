module "naming_iothub" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "iothub"
}

module "naming_eventhub" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "eh"
}

module "naming_storage" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "storage"
}

module "naming_iot_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "iotpe"
}

module "naming_adu" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adu"
}

module "naming_adu_pe" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "adupe"
}

module "naming_role" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "role"
}

locals {
  name_prefix = "${var.app_name}${var.environment}"
  name_suffix = var.suffix != null ? var.suffix : ""
  full_name   = "${local.name_prefix}${local.name_suffix}"

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

# Data source for subnet to ensure it exists
data "azurerm_subnet" "backend" {
  name                 = "backend"
  virtual_network_name = "${var.app_name}-${var.environment}-vnet"
  resource_group_name  = var.resource_group_name

  depends_on = [var.subnet_id] # Explicit dependency on the subnet
}

# Get current subscription details
data "azurerm_subscription" "current" {}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Create IoT Hub
resource "azurerm_iothub" "main" {
  name                = "${local.full_name}iothub"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

  identity {
    type = "SystemAssigned"
  }

  network_rule_set {
    default_action                     = "Deny"
    apply_to_builtin_eventhub_endpoint = false
  }

  public_network_access_enabled = false

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  endpoint {
    type                = "AzureIotHub.EventHub"
    name                = "iothub-events"
    connection_string   = azurerm_eventhub_authorization_rule.main.primary_connection_string
    authentication_type = "keyBased"
  }

  route {
    name           = "events"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["iothub-events"]
    enabled        = true
  }

  tags = local.tags

  depends_on = [
    azurerm_eventhub_namespace.main,
    azurerm_eventhub.main,
    azurerm_eventhub_authorization_rule.main
  ]
}

# Create Event Hub Namespace
resource "azurerm_eventhub_namespace" "main" {
  name                = "${local.full_name}ehns"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1

  tags = local.tags
}

# Create Event Hub
resource "azurerm_eventhub" "main" {
  name                = "${local.full_name}eh"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

# Create Event Hub Authorization Rule
resource "azurerm_eventhub_authorization_rule" "main" {
  name                = "${local.full_name}eh-auth"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.main.name
  resource_group_name = var.resource_group_name

  listen = true
  send   = true
  manage = false
}

# Create IoT Storage Account
resource "azurerm_storage_account" "iot" {
  depends_on = [data.azurerm_subnet.backend]

  name                     = "${local.name_prefix}iotsa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags

  network_rules {
    default_action             = "Allow"  # Temporairement pour Terraform
    virtual_network_subnet_ids = [data.azurerm_subnet.backend.id]
    ip_rules                  = []
  }
}

# Create IoT Hub Consumer Group
resource "azurerm_iothub_consumer_group" "main" {
  name                   = "${local.full_name}cg"
  iothub_name           = azurerm_iothub.main.name
  eventhub_endpoint_name = "events"
  resource_group_name    = var.resource_group_name
}

# Create Private Endpoint for IoT Hub
resource "azurerm_private_endpoint" "iothub" {
  depends_on = [data.azurerm_subnet.backend]

  name                = "${local.full_name}iothub-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.backend.id

  private_service_connection {
    name                           = "${local.full_name}iothub-psc"
    private_connection_resource_id = azurerm_iothub.main.id
    is_manual_connection          = false
    subresource_names            = ["iotHub"]
  }

  tags = local.tags
}

resource "azurerm_iothub_device_update_account" "main" {
  name                = "${var.app_name}${var.environment}adu"
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "adu" {
  depends_on = [data.azurerm_subnet.backend]

  name                = "${local.full_name}adu-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.backend.id

  private_service_connection {
    name                           = "${local.full_name}adu-psc"
    private_connection_resource_id = azurerm_iothub_device_update_account.main.id
    is_manual_connection          = false
    subresource_names            = ["DeviceUpdate"]
  }

  tags = local.tags
}

# Donner le rôle IoT Hub Data Contributor au compte ADU
resource "azurerm_role_assignment" "adu_iothub" {
  scope                = azurerm_iothub.main.id
  role_definition_name = "IoT Hub Data Contributor"
  principal_id         = azurerm_iothub_device_update_account.main.identity[0].principal_id
}
