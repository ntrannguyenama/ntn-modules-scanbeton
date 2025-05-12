output "resource_group_name" {
  value       = module.resource_group.name
  description = "Name of the resource group"
}

# output "app_service_hostname" {
#   value       = module.app_service.app_service_hostname
#   description = "Hostname of the App Service"
# }

output "key_vault_uri" {
  value       = module.key_vault.uri
  description = "URI of the Key Vault"
}

output "key_vault" {
  value       = module.key_vault
  description = "URI of the Key Vault"
}

output "storage_account_name" {
  value       = module.storage.name
  description = "Name of the Storage Account"
}

output "database_server_name" {
  value       = module.database.server_name
  description = "Name of the database server"
}

/*
output "iot_hub_name" {
  value       = var.enable_iot ? module.iot[0].name : null
  description = "Name of the IoT Hub (if enabled)"
}

output "data_explorer_uri" {
  value       = var.enable_adx ? module.data_explorer[0].uri : null
  description = "URI of the Data Explorer cluster (if enabled)"
}

output "ai_openai_endpoint" {
  description = "OpenAI endpoint URL"
  value       = var.enable_ai ? module.ai[0].openai_endpoint : null
}

output "ai_search_endpoint" {
  description = "Cognitive Search endpoint URL"
  value       = var.enable_ai ? module.ai[0].search_endpoint : null
}
*/