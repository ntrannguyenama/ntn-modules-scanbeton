output "app_service_plan_id" {
  value       = azurerm_service_plan.main.id
  description = "The ID of the App Service Plan"
}