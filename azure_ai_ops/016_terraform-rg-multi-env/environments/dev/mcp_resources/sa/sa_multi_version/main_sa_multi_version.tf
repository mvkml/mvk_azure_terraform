locals {
  l_evn_version = var.app_context.environment_version == "" ? "001" : var.app_context.environment_version
}

locals {
  storage_accounts_versioned = [
    for sa in var.storage_accounts : merge(sa, {
      name = "${sa.name}${local.l_evn_version}"
    })
  ]
}


resource "azurerm_storage_account" "storage_accounts" {
  for_each = {
    for sa in local.storage_accounts_versioned :
    sa.name => sa if sa.is_active
  }

  name                            = each.value.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  account_kind                    = each.value.account_kind
  access_tier                     = each.value.access_tier
  is_hns_enabled                  = each.value.is_hns_enabled
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = var.common_tags

  timeouts {
    create = "10m"
    update = "10m"
    read   = "5m"
    delete = "10m"
  }
}


locals {
  active_container_group = flatten([
    for sa in local.storage_accounts_versioned : [
      for container in sa.containers : {
        storage_account_name  = sa.name
        container_name        = container.name
        container_access_type = container.container_access_type
        metadata              = container.metadata
      } if container.is_active
    ] if sa.is_active
  ])
}


resource "azurerm_storage_container" "containers" {
  for_each = { for idx, container in local.active_container_group : "${container.storage_account_name}-${container.container_name}" => container }

  name                  = each.value.container_name
  storage_account_id    = azurerm_storage_account.storage_accounts[each.value.storage_account_name].id
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}


locals {
  active_blob_groups = flatten([
    for sa in local.storage_accounts_versioned : [
      for container in sa.containers : [
        for blob in container.blobs : {
          storage_account_name = sa.name
          container_name       = container.name
          blob_name            = blob.name
          blob_type            = blob.type
          blob_source          = blob.source
          blob_pattern         = blob.pattern
          blob_items           = [
            for item in fileset("${path.root}/${blob.source}", blob.pattern) :
            item
          ]
        } if blob.is_active
      ] if container.is_active
    ] if sa.is_active
  ])
}


locals {
  active_blobs = flatten([
    for blob_group in local.active_blob_groups :
    length(blob_group.blob_items) > 0 ?
    [
      for blob_item in blob_group.blob_items : {
        storage_account_name = blob_group.storage_account_name
        container_name       = blob_group.container_name
        blob_name            = "${blob_group.blob_name}/${blob_item}"
        blob_type            = blob_group.blob_type
        blob_item_source     = "${path.root}/${blob_group.blob_source}/${blob_item}"
      }
    ]
    :
    [
      {
        storage_account_name = blob_group.storage_account_name
        container_name       = blob_group.container_name
        blob_name            = blob_group.blob_name
        blob_type            = blob_group.blob_type
        blob_item_source     = "${path.root}/${blob_group.blob_source}"
      }
    ]
  ])
}


resource "azurerm_storage_blob" "blobs" {
  for_each = {
    for blob in local.active_blobs :
    "${blob.storage_account_name}-${blob.container_name}-${blob.blob_name}" => blob
  }

  name                   = each.value.blob_name
  storage_account_name   = azurerm_storage_account.storage_accounts[each.value.storage_account_name].name
  storage_container_name = azurerm_storage_container.containers["${each.value.storage_account_name}-${each.value.container_name}"].name
  type                   = each.value.blob_type
  source                 = each.value.blob_item_source
}
