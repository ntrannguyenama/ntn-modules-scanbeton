resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each = { for dns in var.dns_zone : dns.name => dns }

  name                = each.value.private_dns_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  for_each = local.virtual_network_private_dns_zone

  name                  = lower("${var.app_name}-${var.environment}-link")
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone[each.key].name
  virtual_network_id    = azurerm_virtual_network.main.id
}
