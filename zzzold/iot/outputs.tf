output "id" {
  value = azurerm_iothub.main.id
}

output "name" {
  value = azurerm_iothub.main.name
}

output "hostname" {
  value = azurerm_iothub.main.hostname
}

output "event_hub_connection_string" {
  value     = azurerm_eventhub_authorization_rule.main.primary_connection_string
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.iot.name
}

output "eventhub_name" {
  value = azurerm_eventhub.main.name
}

output "eventhub_namespace" {
  value = azurerm_eventhub_namespace.main.name
}
