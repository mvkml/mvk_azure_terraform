
resource "azurerm_log_analytics_workspace" "ws" {
  name                = var.log_analytics_workspace.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.log_analytics_workspace.sku
  #   Free
  # PerGB2018
  # Unlimited
  retention_in_days   = var.log_analytics_workspace.retention_in_days
  tags                = var.tags
  # can I have list of skus 
  # 
}
