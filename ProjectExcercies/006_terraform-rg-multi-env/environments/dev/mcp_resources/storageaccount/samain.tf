locals {
	active_container_list = flatten([
		for sa in var.storage_accounts : [
			for container in sa.containers : {
				storage_account_name  = sa.name
				container_name        = container.name
				container_access_type = container.container_access_type
				metadata              = container.metadata
			} if container.is_active
		] if sa.is_active
	])
}



resource "azurerm_storage_account" "storage_accounts" {
	for_each = {
		for sa in var.storage_accounts :
		sa.name => sa if sa.is_active
	}

	name                     = each.value.name
	resource_group_name      = var.resource_group_name
	location                 = var.location
	account_tier             = each.value.account_tier
	account_replication_type = each.value.account_replication_type
	account_kind             = each.value.account_kind
	access_tier              = each.value.access_tier

	min_tls_version                 = "TLS1_2"
	allow_nested_items_to_be_public = false

	tags = var.common_tags
}

resource "azurerm_storage_container" "containers" {
  for_each = { for idx, container in local.active_container_list : "${container.storage_account_name}-${container.container_name}" => container }
  
  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_accounts[each.value.storage_account_name].name #each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata

}

