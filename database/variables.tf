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

variable "administrator_login" {
  type        = string
  description = "The administrator login name for the SQL server"
  default     = "sqladmin"
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator login password"
  sensitive   = true
}

variable "database_max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes"
  default     = 2
}

variable "database_sku_name" {
  type        = string
  description = "Specifies the name of the sku used by the database"
  default     = "Basic"
}

variable "zone_redundant" {
  type        = bool
  description = "Whether or not the database is zone redundant"
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the private endpoint"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "sql" {
  type = object({
    version = optional(string)
    administrator_login = optional(string)
    minimum_tls_version = optional(string)
    public_network_access_enabled = optional(bool)
    outbound_network_restriction_enabled = optional(bool)
    sku_name = optional(string)
    max_size_gb = optional(number)
    geo_backup_enabled = optional(bool)
  })  
}