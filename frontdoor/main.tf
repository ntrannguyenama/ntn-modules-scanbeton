module "naming_front_door" {
  source        = "../naming"
  app_name      = var.app_name
  environment   = var.environment
  suffix        = var.suffix
  resource_type = "frontdoor"
}

# Define the Azure Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = module.naming_front_door.resource_name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor" # Use "Premium_AzureFrontDoor" for Premium tier if needed
}

# Define the Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "frontdoor_endpoint" {
  name                     = "scanbeton-frontdoor-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

# # Define the Origin Group (equivalent to backend pool)
resource "azurerm_cdn_frontdoor_origin_group" "backend" {
  name                     = "webapp-backend"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id

  # Load balancing settings
  load_balancing {
    sample_size                        = 4
    successful_samples_required         = 3
    additional_latency_in_milliseconds = 50 # Adjust as needed
  }

  # Health probe settings
  health_probe {
    path                = "/api"
    protocol            = "Http"
    interval_in_seconds = 100
    request_type        = "HEAD" # Optional: Use HEAD for lighter probes
  }
}

# Define the Origin (equivalent to backend)
resource "azurerm_cdn_frontdoor_origin" "backend" {
  name                           = "webapp-backend"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.backend.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = "scanbeton-dev-app.azurewebsites.net"
  origin_host_header             = "scanbeton-dev-app.azurewebsites.net"
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
}

# # Define the Origin Group (equivalent to backend pool)
resource "azurerm_cdn_frontdoor_origin_group" "frontend" {
  name                     = "storage-frontend"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id

  # Load balancing settings
  load_balancing {
    sample_size                        = 4
    successful_samples_required         = 3
    additional_latency_in_milliseconds = 50 # Adjust as needed
  }

  # Health probe settings
  health_probe {
    path                = "/*"
    protocol            = "Http"
    interval_in_seconds = 100
    request_type        = "HEAD" # Optional: Use HEAD for lighter probes
  }
}

# Define the Origin (equivalent to backend)
resource "azurerm_cdn_frontdoor_origin" "frontend" {
  name                           = "storage-frontend"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.frontend.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = "scanbetondevst.z6.web.core.windows.net"
  origin_host_header             = "scanbetondevst.z6.web.core.windows.net"
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
}

# Define the Route (equivalent to routing rule)
resource "azurerm_cdn_frontdoor_route" "routebackend" {
  name                          = "backend-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.backend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.backend.id]

  patterns_to_match             = ["/api"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "MatchRequest"
  link_to_default_domain        = true # Links the route to the default endpoint domain
}

# Define the Route (equivalent to routing rule)
resource "azurerm_cdn_frontdoor_route" "routefrontend" {
  name                          = "frontend-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontend.id]

  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "MatchRequest"
  link_to_default_domain        = true # Links the route to the default endpoint domain
}

# # Optional: Output the Front Door hostname for reference
# output "frontdoor_hostname" {
#   value = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.host_name
# }
