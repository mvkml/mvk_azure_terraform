output "storage_account_names" {
  description = "Created storage account names"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.name
  }
}
# azurerm_storage_account.storage_accounts["sa1"].name

output "storage_account_ids" {
  description = "Created storage account ids"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.id
  }
}
# azurerm_storage_account.storage_accounts["sa1"].id

output "primary_blob_endpoints" {
  description = "Primary blob endpoints"
  value = {
    for key, sa in azurerm_storage_account.storage_accounts : key => sa.primary_blob_endpoint
  }
}
# azurerm_storage_account.storage_accounts["sa1"].primary_blob_endpoint