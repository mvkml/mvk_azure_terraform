locals {

/*

project_name = "mcp-ai"
location_id  = "cin" # this is the location code that will be used in the resource naming convention, not the location name
environment   = "dev"
client_name    = "etna"
repository_short_name = "ubcliams"
resource_type = "rg"
environment_code = "p27" # this is an example of a project code that can be used in the resource naming convention, it can be any code that helps identify the project or application the resource belongs to

# etna-ubcliams-mcp-ai-cin-rg-p27
*/


 rg_name = "${var.client_name}-${var.repository_short_name}-${var.project_name}-${var.location_id}-${var.resource_type}-p28"
#  rg_name = "${var.client_name}-${var.repository_short_name}-${var.project_name}-${var.location_id}-${var.resource_type}-${var.environment_code}"
# rg_name = "${var.project_name}-${var.environment}-rg"

  common_tags = {
    project     = var.project_name
    environment = var.environment
    managedBy   = var.managedby
  }
}

module "resource_group" {
  source = "../../modules/resource_group"

  rg_name  = local.rg_name
  location = var.location
  tags     = local.common_tags
}


# module "storageaccount" {

#   source = "./mcp_resources/storageaccount"

#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   common_tags         = local.common_tags
#   storage_accounts = var.storage_accounts
# }


# module "ai_search" {
#   source = "./mcp_resources/aiops/ai_search"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   ai_search_tags      = local.common_tags
#   ai_search_services  = var.ai_search_services 
# }


# locals {
#   m_az_open_ai_tags = {
#     project     = var.project_name
#     environment = var.environment
#     managedBy   = var.managedby
#     module = "mcp_az_open_ai"
#   }
# }

# module "m_az_open_ai" {
#   source = "./mcp_resources/aiops/az_open_ai"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   var_az_openai_tags  = local.m_az_open_ai_tags
#   var_az_openai       = var.var_az_openai
# }


locals {
  tags_az_keyvault = {
    project     = var.project_name
    environment = var.environment
    managedBy   = var.managedby
    module = "ubcliams_az_keyvault"
  }
}

module "m_az_keyvault" {
  source = "./mcp_resources/az_keyvault"   
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  # can  you confirm is clientid or object id should be used here for the access policy of the key vault, I have seen both being used in different examples, but I want to make sure we are using the correct one for our use case
  object_id           = var.client_id
  tags                = local.tags_az_keyvault
  az_keyvault_values  = var.az_keyvault_values
}