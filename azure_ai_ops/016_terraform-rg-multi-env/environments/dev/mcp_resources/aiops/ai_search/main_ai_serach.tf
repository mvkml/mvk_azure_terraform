locals {
  l_ai_search_services = [
    for k, v in var.ai_search_services : {
      name            = v.name
      sku             = v.sku
      replica_count   = v.replica_count
      partition_count = v.partition_count
      location        = var.location
      is_active       = v.is_active
    } if v.is_active
  ]
}
 

resource "azurerm_search_service" "ai_search_services" {
  for_each = {
    for idx, v in local.l_ai_search_services : v.name => v
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location

  sku             = each.value.sku
  replica_count   = each.value.replica_count
  partition_count = each.value.partition_count
  tags            = var.tags
}