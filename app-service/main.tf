data "azurerm_client_config" "current" {}

resource "azurerm_linux_web_app" "main" {
   name                = var.name
   resource_group_name = var.resource_group_name
   location            = var.location
   service_plan_id     = var.service_plan_id
 
   site_config {
    minimum_tls_version = "1.2"
     application_stack {
       node_version = local.web_app.node_version
     }
     always_on = false
     app_command_line = local.web_app.app_command_line
     cors {
      allowed_origins = local.web_app.allowed_origins
      support_credentials = local.web_app.support_credentials
     }
   }
   app_settings = var.web_app.app_settings
   https_only = true
   

   identity {
     type = "SystemAssigned"
   }

  logs {
    application_logs {
      file_system_level = "Error"
    }
    http_logs {
      file_system {
        retention_in_days = 0
        retention_in_mb   = 100
      }
    }
  }
 
   tags = local.merged_tags
 }

 resource "azurerm_key_vault_access_policy" "webapp" {
  key_vault_id = var.key_vault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_linux_web_app.main.identity[0].principal_id

  secret_permissions = ["Get"]
}