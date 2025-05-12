variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region location"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "suffix" {
  type        = string
  description = "Optional suffix for resource names"
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for the Data Explorer cluster"
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the cluster"
  default     = "Standard_D4s_v3"
}

variable "sku_capacity" {
  type        = number
  description = "The capacity of the Data Explorer cluster"
  default     = 2
}

variable "auto_stop_enabled" {
  type        = bool
  description = "Should the cluster auto stop when idle"
  default     = true
}

variable "streaming_ingestion_enabled" {
  type        = bool
  description = "Enable streaming ingestion"
  default     = true
}

variable "databases" {
  description = "Map of databases to create with their configurations"
  type = map(object({
    hot_cache_period  = string
    soft_delete_period = string
  }))
  default = {
    telemetry = {
      hot_cache_period  = "P7D"
      soft_delete_period = "P30D"
    }
    analytics = {
      hot_cache_period  = "P14D"
      soft_delete_period = "P90D"
    }
  }
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault for storing secrets"
}

variable "app_service_principal_id" {
  type        = string
  description = "Principal ID of the App Service managed identity to grant Data Explorer access"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
