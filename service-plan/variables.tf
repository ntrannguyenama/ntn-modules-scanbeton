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

variable "service_plan" {
   type = object({
       sku_name      = optional(string)
       os_type       = optional(string)
       worker_count = optional(number)
     })
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}