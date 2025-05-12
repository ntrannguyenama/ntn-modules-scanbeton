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

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
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
    }
  ]
}

variable "dns_zone" {
  type = list(object({
    name = string
    private_dns_name = string
  }))
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
  description = "List of network security group rules"
  default = [
    {
      name                       = "allow_web"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "80,443"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}