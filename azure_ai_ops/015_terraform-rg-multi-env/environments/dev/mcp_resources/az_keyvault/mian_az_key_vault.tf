

resource "azurerm_key_vault" "re_key_vault" {
 
  name                        = var.az_keyvault.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  #   Standard → software security  ( Stock Keeping Unit SKU)
  #   Premium → hardware security (HSM)
  sku_name                    = var.az_keyvault.sku_name
  soft_delete_retention_days  = var.az_keyvault.soft_delete_retention_days
  purge_protection_enabled    = var.az_keyvault.purge_protection_enabled
  tags                        = var.tags

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Update",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Purge"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Update",
      "Delete",
      "Backup",
      "Restore",
      "Recover",
      "Purge"
    ]
  }
}