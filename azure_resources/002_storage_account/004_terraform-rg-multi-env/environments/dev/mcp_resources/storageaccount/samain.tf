resource "azurerm_storage_account" "storage_accounts" {
  for_each = var.storage_accounts

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