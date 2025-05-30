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