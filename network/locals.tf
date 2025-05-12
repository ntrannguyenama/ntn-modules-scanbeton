locals {  
virtual_network_private_dns_zone = {
    for private_dns_zone in var.dns_zone : "${private_dns_zone.name}" => {
      name             = private_dns_zone.name
      private_dns_name = private_dns_zone.private_dns_name
    }
  }
}