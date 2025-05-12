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

variable "lock_level" {
  type        = string
  description = "Specifies the level of lock. Possible values are Empty (no lock), CanNotDelete and ReadOnly."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}