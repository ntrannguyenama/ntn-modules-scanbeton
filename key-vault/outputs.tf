output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "The URI of the Key Vault"
}

output "app_secret" {
  value       = random_password.app_secret.result
  description = "Generated application secret"
  sensitive   = true
}

output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}
