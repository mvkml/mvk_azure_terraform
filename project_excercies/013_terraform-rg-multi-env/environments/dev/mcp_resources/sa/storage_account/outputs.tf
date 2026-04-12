output "Name" {
  value =  azurerm_storage_account.r_storage_account.name
}
# azurerm_storage_account.storage_account_gen2  ["sa1"].name

output "Id" {
   value= azurerm_storage_account.r_storage_account.id
}
# azurerm_storage_account.storage_account_gen2["sa1"].id
 