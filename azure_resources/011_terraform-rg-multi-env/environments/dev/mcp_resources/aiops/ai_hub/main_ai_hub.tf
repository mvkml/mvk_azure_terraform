


 

module "m_ai_hubaz_keyvault" {
  source = "../../../mcp_resources/az_keyvault"   
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  # can  you confirm is clientid or object id should be used here for the access policy of the key vault, I have seen both being used in different examples, but I want to make sure we are using the correct one for our use case
  object_id           = var.object_id
  tags                = var.tags
  az_keyvault_values  = var.az_keyvault_values
}
