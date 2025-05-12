variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "suffix" {
  type        = string
  description = "Optional suffix for resource names"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for private endpoints"
}

variable "storage_account" {
  type = object({
    account_tier = optional(string)
    account_replication_type = optional(string)
    account_kind = optional(string)
    https_traffic_only_enabled = optional(bool)
    min_tls_version = optional(string)
    allow_nested_items_to_be_public = optional(bool)
  })
}