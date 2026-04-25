locals {
  l_evn_version = var.app_context.environment_version == "" ? "001" : var.app_context.environment_version
}



locals {
  l_names = {
    open_ai_name = "etna-mcp-ai-dev-cus${local.l_evn_version}"
  }
}





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


 rg_name = "${var.client_name}-${var.repository_short_name}-${var.project_name}-${var.location_id}-${var.resource_type}-${local.l_evn_version}"
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


module "m_hr02_ai_search" {
  source = "./mcp_domain_modules/hr/hr02_ai_search"   
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  app_context         = var.app_context
}


# module "w01_m_ai_hub" {
#   source = "./mcp_resources/aiops/w01_ai_hub"   
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   tenant_id           = var.tenant_id
#   object_id           = var.client_id
#   app_context         = var.app_context
# }



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

# locals{
# var_az_openai = {
#   etna-mcp-ai-az-openai-cus001 = {
#     name            = local.l_names.open_ai_name
#     sku_name        = "S0"  #Statndard S0
#     location        = var.location
#     network_type    = "Public"
#     kind            = "OpenAI"
#     custom_subdomain_name = local.l_names.open_ai_name
#     public_network_access_enabled = true
#     description      = "This is a sample Azure OpenAI resource for development and testing purposes."
#     is_active        = true
#   } 
# }
# }

# module "m_az_open_ai" {
#   source = "./mcp_resources/aiops/az_open_ai"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   var_az_openai_tags  = local.m_az_open_ai_tags
#   var_az_openai       = local.var_az_openai
# }


# locals {
#   tags_az_keyvault = {
#     project     = var.project_name
#     environment = var.environment
#     managedBy   = var.managedby
#     module = "ubcliams_az_keyvault"
#   }
# }

# module "m_az_keyvault" {
#   source = "./mcp_resources/az_keyvault"   
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   tenant_id           = var.tenant_id
#   # can  you confirm is clientid or object id should be used here for the access policy of the key vault, I have seen both being used in different examples, but I want to make sure we are using the correct one for our use case
#   object_id           = var.client_id
#   tags                = local.tags_az_keyvault
#   az_keyvault_values  = var.az_keyvault_values
# }


# locals {
#   tags_ai_hub_az_keyvault = {
#     project     = var.project_name
#     environment = var.environment
#     managedBy   = var.managedby
#     module = "ai_hub_ub_claims"
#   }
# }

# module "m_ai_hub" {
#   source = "./mcp_resources/aiops/ai_hub"   
#   resource_group_name = module.resource_group.resource_group_name
#   location            = var.location
#   tenant_id           = var.tenant_id
#   object_id           = var.client_id
#   tags                = local.tags_ai_hub_az_keyvault
#   az_keyvault_values  = var.az_keyvault_values
#   storage_accounts     = var.storage_accounts
# }





