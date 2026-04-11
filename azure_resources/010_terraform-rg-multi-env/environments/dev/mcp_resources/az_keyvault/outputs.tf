output "output_key_vault_names" {
  description = "Created key vault names"
  value = {
    for key, kv in azurerm_key_vault.re_key_vaults : key => kv.name
  }
}