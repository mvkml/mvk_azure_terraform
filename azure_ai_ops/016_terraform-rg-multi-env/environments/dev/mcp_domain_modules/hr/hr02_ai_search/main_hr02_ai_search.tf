locals {
  l_evn_version = var.app_context.environment_version == "" ? "001" : var.app_context.environment_version
}


locals {
  l_names = {
    key_vault_name = "kv-mcp-ai-dev-${local.l_evn_version}"
    sa_name        = "samcpaidev${local.l_evn_version}"
    container_registry_name = "cr-mcp-ai-dev-${local.l_evn_version}"
    ml_workspace_name = "mlw-mcp-ai-dev-${local.l_evn_version}"
    application_insights_name = "appi-mcp-ai-dev-${local.l_evn_version}"
    foundry_cognitive_account_name = "ai-fou-ub-mcp-ai-dev-${local.l_evn_version}"
    foundry_custom_subdomain_name = "ai-sub-domain-dev-${local.l_evn_version}"
    project_name = "mcp_az_open_ai-dev-${local.l_evn_version}"
    log_analytics_workspace_name = "law-ai-hub-dev-${local.l_evn_version}"
    cosmosdb_account_name = "cosmosdb-mcp-ai-dev-${local.l_evn_version}"
    cosmosdb_database_name = "db-mcp-ai-dev-${local.l_evn_version}"
    cosmosdb_container_name = "container-mcp-ai-dev-${local.l_evn_version}"
    open_ai_name = "etna-${var.app_context.client_name}-az-openai-cus001"
  }
}


#  locals {
#    l_resource_count = {
#     sa_count = true
#     key_vault_count = false
#     foundry_count = false
#     application_insights_count = false
#     cosmosdb_count = true
#    }
#  }
  

#--------------------------------------------------------------
# Azure Storage Account
#--------------------------------------------------------------

  
 
 locals {
   l_sa_tags = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
    "Module"       = "HR01_SA"
   }
 }

 
module "m_sa_multi_version1" {
  source =  "../../../mcp_resources/sa/sa_multi_version"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_context         = var.app_context
  common_tags         = local.l_sa_tags
  storage_accounts = var.storage_accounts
}

 
 



locals {
  tags_m_ai_search = {
    project_name           = var.app_context.project_name
    location               = var.app_context.location
    environment            = var.app_context.environment
    client_name            = var.app_context.client_name
    environment_code       = var.app_context.environment_code
    environment_version    = var.app_context.environment_version
    managed_by                 = var.app_context.managed_by
  }
}


 
module "m_az_open_ai" {
  source = "../../../mcp_resources/aiops/az_open_ai"
  resource_group_name = var.resource_group_name
  location            = var.location
  var_az_openai_tags  = local.tags_m_ai_search
  var_az_openai       = var.var_az_openai
}



module "m_ai_search" {
  source = "../../../mcp_resources/aiops/ai_search"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_context         = var.app_context
  tags      = local.tags_m_ai_search
}









 