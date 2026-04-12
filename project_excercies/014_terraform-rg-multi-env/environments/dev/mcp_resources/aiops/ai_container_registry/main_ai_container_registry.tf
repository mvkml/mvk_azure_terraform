
resource "azurerm_container_registry" "r_acr" {
  name                = var.container_registry.name
  resource_group_name = var.container_registry.resource_group_name
  location            = var.container_registry.location
  sku                 = var.container_registry.sku
  admin_enabled       = var.container_registry.admin_enabled
  tags              = var.tags
}
