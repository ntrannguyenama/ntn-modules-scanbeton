resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = replace(upper("${var.app_name}-${var.environment}-${var.secret.name}"), "_", "-")
  value        = var.secret.value
  key_vault_id = var.key_vault.id
}