resource "azurerm_search_service" "ai_search_services" {
  for_each = var.ai_search_services

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku             = each.value.sku
  replica_count   = each.value.replica_count
  partition_count = each.value.partition_count
  tags = var.ai_search_tags
}