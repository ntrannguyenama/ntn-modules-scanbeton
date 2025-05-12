locals {
    sku_name = var.key_vault.sku_name != null ? var.key_vault.sku_name : "standard"
    secret = var.key_vault.secret != null ? var.key_vault.secret : []
}