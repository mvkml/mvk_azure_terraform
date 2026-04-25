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


 locals {
   l_resource_count = {
    sa_count = true
    key_vault_count = false
    foundry_count = false
    application_insights_count = false
    cosmosdb_count = true
   }
 }
 



 locals {
   l_az_keyvault = {
    name                        = local.l_names.key_vault_name
    location                    = var.location
    tenant_id                   = var.tenant_id
    object_id                   = var.object_id
    sku_name                    = "standard"
    soft_delete_enabled         = true
    soft_delete_retention_days  = 90
    purge_protection_enabled    = false
    description                 = "Key Vault for AI Hub development environment"
    is_active                   = true
   }
  }
 

 locals {
    l_keyvault_tags = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
 }
 }
 


module "m_ai_hub_keyvault" {

  count = local.l_resource_count.key_vault_count ? 1 : 0
  source = "../../../mcp_resources/az_keyvault"   

  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  # can  you confirm is clientid or object id should be used here for the access policy of the key vault, I have seen both being used in different examples, but I want to make sure we are using the correct one for our use case
  object_id           = var.object_id
  tags                = local.l_keyvault_tags
  az_keyvault         = local.l_az_keyvault  
}

 
 locals {
   l_storage_account = {
    name                     = local.l_names.sa_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    is_hns_enabled          = false
   }
 }
 
 locals {
   l_sa_tags = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
   }
 }

 
 module "m_ai_hub_storage_account" {
    count = local.l_resource_count.sa_count ? 1 : 0

  source = "../../../mcp_resources/sa/storage_account"   
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.l_sa_tags
  storage_account  = local.l_storage_account
 }


locals {
  l_log_analytics_workspace = {
    name                = local.l_names.log_analytics_workspace_name
    location            = var.location
    sku                 = "PerGB2018"
    retention_in_days   = 30
  }
}


#log analytics workspace is a dependency for the ai hub module, so we need to create it before the ai hub module is created, but we can create it in the same main.tf file as the ai hub module, we just need to make sure that the log analytics workspace is created before the ai hub module is created by using the depends_on attribute in the ai hub module
module "m_ai_hub_la_ws" {

  # count = local.l_resource_count.foundry_count ? 1 : 0

  source = "../../../mcp_resources/log_analy_workspace"
  resource_group_name = var.resource_group_name
  location            = var.location
  log_analytics_workspace = local.l_log_analytics_workspace
}


locals {
  l_application_insights = {
    name = local.l_names.application_insights_name
    location = var.location
    resource_group_name = var.resource_group_name
    application_type = "web"
    workspace_id = module.m_ai_hub_la_ws.workspace_id
    
  }
}

locals {
  l_tags_application_insights = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"

  }
}




module "m_ai_hub_application_insights" {
  count = local.l_resource_count.application_insights_count ? 1 : 0

  source = "../../../mcp_resources/app_insight"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_insights = local.l_application_insights
  tags                = local.l_tags_application_insights
}



module "m_ai_hub_foundry" {

  count = local.l_resource_count.foundry_count ? 1 : 0

  source = "../../../mcp_resources/aiops/ai_foundry"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_context = var.app_context
}



module "m_ai_hub_cosmosdb" {

  count = local.l_resource_count.cosmosdb_count ? 1 : 0

  source = "../../../mcp_resources/az_cosmos_db"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_context = var.app_context
}
