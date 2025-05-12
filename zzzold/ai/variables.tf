variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "suffix" {
  description = "Optional suffix for resource names"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the AI resources"
  type        = string
}

variable "naming" {
  description = "Naming module"
  type = object({
    app_name      = string
    environment   = string
    suffix        = string
    resource_type = string
  })
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "ID of the subnet to deploy private endpoints"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault to store secrets"
  type        = string
}

variable "openai_model" {
  description = "OpenAI model to deploy"
  type        = string
  default     = "gpt-4"
}

variable "openai_capacity" {
  description = "OpenAI deployment capacity"
  type        = number
  default     = 1
}

variable "cognitive_search_sku" {
  description = "SKU for Azure Cognitive Search"
  type        = string
  default     = "standard"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}
