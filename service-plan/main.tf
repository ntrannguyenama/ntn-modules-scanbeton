resource "azurerm_service_plan" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type            = local.os_type
  sku_name           = local.sku_name
  worker_count = local.worker_count

  tags = local.merged_tags
}