

resource "azurerm_application_insights" "r_appi" {
  name                = var.application_insights.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights.application_type
  workspace_id        = var.application_insights.workspace_id
  tags                = var.tags
}
