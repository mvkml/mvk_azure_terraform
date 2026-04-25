output "ai_search_service_names" {
  value = { for k, v in azurerm_search_service.ai_search_services : k => v.name }
  description = "The names of the AI Search services created in this environment"
}