
resource "azurerm_machine_learning_workspace" "ai_hub" {
  name                = var.ml_workspace.name
  location            = var.ml_workspace.location
  resource_group_name = var.ml_workspace.resource_group_name

  application_insights_id = var.ml_workspace.application_insights_id
  key_vault_id            = var.ml_workspace.key_vault_id
  storage_account_id      = var.ml_workspace.storage_account_id
  container_registry_id   = var.ml_workspace.container_registry_id

  identity {
    type = "SystemAssigned"
  }
}
