locals {
    account_tier                    = var.storage_account.account_tier != null ? var.storage_account.account_tier : "Standard"
    account_replication_type        = var.storage_account.account_replication_type != null ? var.storage_account.account_recplication_type : "LRS"
    account_kind                    = var.storage_account.account_kind != null ? var.storage_account.account_kind : "StorageV2"
    https_traffic_only_enabled      = var.storage_account.https_traffic_only_enabled != null ? var.storage_account.https_traffic_only_enabled : true
    min_tls_version                = var.storage_account.min_tls_version != null ? var.storage_account.min_tls_version : "TLS1_2"
    allow_nested_items_to_be_public = var.storage_account.allow_nested_items_to_be_public != null ? var.storage_account.allow_nested_items_to_be_public : false
}