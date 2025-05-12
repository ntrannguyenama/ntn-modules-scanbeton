output "openai_endpoint" {
  description = "OpenAI endpoint URL"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "search_endpoint" {
  description = "Cognitive Search endpoint URL"
  value       = "https://${azurerm_search_service.main.name}.search.windows.net"
}
