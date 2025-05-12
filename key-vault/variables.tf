variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Key Vault"
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
  default     = null
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "object_id" {
  description = "The object ID of the current user"
  type        = string
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses that are allowed to access the Key Vault"
  default     = []
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs that are allowed to access the Key Vault"
  default     = []
}

variable "create_private_endpoint" {
  type        = bool
  description = "Whether to create a private endpoint for the Key Vault"
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to create the private endpoint in"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "admin_object_ids" {
  description = "Map of admin object IDs to grant access to the Key Vault"
  type        = map(string)
  default     = {}
}

variable "key_vault" {
  type = object({
    sku_name = optional(string)
    secret = optional(list(
      object({
        name    = string
        value   = optional(string)
      })
    ))
  })
}