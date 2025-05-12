variable "name" {
  type = string
}

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
  default     = null
}

variable "backend_subnet_id" {
  type        = string
  description = "ID of the subnet for the backend app service"
}

variable "key_vault_url" {
  type        = string
  description = "URL of the Key Vault"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault for access policy"
}

variable "frontend_url" {
  type        = string
  description = "URL of the frontend application for CORS configuration"
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the App Service Plan"
  default     = "F1"
}

variable "web_app" {
   type = object({
      name = optional(string)
      suffix = optional(string)
       sku_name      = optional(string)
       os_type       = optional(string)
       app_settings  = optional(any)
       node_version  = optional(string)
       app_command_line = string
       worker_count = optional(number)
       support_credentials = optional(bool)
       allowed_origins = optional(any)
     })
 }

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "service_plan_id" {
  type = any
}