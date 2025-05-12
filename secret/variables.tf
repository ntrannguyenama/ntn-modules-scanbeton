variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "key_vault" {
  type = object({
    id       = string
    name     = string
    location = string
  })
}

variable "secret" {
  type = object({
    name    = string
    value   = string
  })
}
