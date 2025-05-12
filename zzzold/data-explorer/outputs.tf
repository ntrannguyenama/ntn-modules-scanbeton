output "cluster_id" {
  value       = azurerm_kusto_cluster.main.id
  description = "The ID of the Data Explorer cluster"
}

output "cluster_name" {
  description = "The name of the Data Explorer cluster"
  value       = azurerm_kusto_cluster.main.name
}

output "cluster_uri" {
  description = "The URI of the Data Explorer cluster"
  value       = azurerm_kusto_cluster.main.uri
}

output "adx_principal_id" {
  description = "The principal ID of the Data Explorer cluster"
  value       = azurerm_kusto_cluster.main.identity[0].principal_id
}

output "principal_id" {
  description = "The Principal ID of the Data Explorer cluster's managed identity"
  value       = azurerm_kusto_cluster.main.identity[0].principal_id
}

output "id" {
  value = azurerm_kusto_cluster.main.id
}

output "name" {
  value = azurerm_kusto_cluster.main.name
}

output "uri" {
  value = azurerm_kusto_cluster.main.uri
}

output "data_ingestion_uri" {
  value = azurerm_kusto_cluster.main.data_ingestion_uri
}

output "databases" {
  value = {
    for name, db in azurerm_kusto_database.databases : name => {
      id   = db.id
      name = db.name
    }
  }
}
