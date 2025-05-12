output "id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.web.id
}

output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.web.name
}

output "primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location"
  value       = azurerm_storage_account.web.primary_web_host
}

output "primary_connection_string" {
  description = "The connection string associated with the primary location"
  value       = azurerm_storage_account.web.primary_connection_string
  sensitive   = true
}

output "connection_string" {
  value     = azurerm_storage_account.web.primary_connection_string
  sensitive = true
}
/*
output "cdn_url" {
  description = "The URL of the CDN endpoint"
  value       = "https://${azurerm_cdn_endpoint.main.fqdn}"
}
*/