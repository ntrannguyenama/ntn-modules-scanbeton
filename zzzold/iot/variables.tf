variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Name of the environment"
  type        = string
}

variable "suffix" {
  description = "Suffix to add to resource names"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the IoT Hub"
  type        = string
  default     = "S1"
}

variable "sku_capacity" {
  description = "The capacity of the IoT Hub"
  type        = number
  default     = 1
}

variable "storage_connection_string" {
  description = "Connection string for the storage account"
  type        = string
}

variable "subnet_id" {
  description = "ID of the backend subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
