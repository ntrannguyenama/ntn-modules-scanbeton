variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment (dev, uat, prod)"
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "enable_iot" {
  type        = bool
  description = "Whether to enable IoT Hub resources"
  default     = false
}

variable "enable_adx" {
  type        = bool
  description = "Whether to enable Azure Data Explorer resources"
  default     = false
}

variable "enable_ai" {
  type        = bool
  description = "Enable AI features with OpenAI and RAG"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "List of subnet configurations"
  default = [
    {
      name           = "frontend"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "backend"
      address_prefix = "10.0.2.0/24"
      private_endpoint_network_policies_enabled = true
    }
  ]
}

variable "web_app" {
  type = any
}

variable "sql" {
  type = any
}

variable "key_vault" {
  type = any
}

variable "storage_account" {
  type = any
}

variable "service_plan" {
  type = any
}

variable "dns_zone" {
  type = any
}

variable "ai" {
  type = any
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range         = string
    destination_port_range    = string
    source_address_prefix     = string
    destination_address_prefix = string
  }))
  description = "Network security group rules"
  default     = []
}

variable "key_vault_admin_ids" {
  description = "Map of admin names to their Azure AD Object IDs that should have admin access to the Key Vault"
  type        = map(string)
  default     = {}
}

variable "create_private_endpoints" {
  description = "Whether to create private endpoints for Azure services"
  type        = bool
  default     = false
}
