output "ai_search_service_names" {
  value = { for k, v in azurerm_cognitive_account.rsc_az_openai : k => v.name }
  description = "The names of the AI Search services created in this environment"
}