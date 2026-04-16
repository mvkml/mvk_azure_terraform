locals {
  l_values = {
    key_vault_name = "kvaihubdev131014"
    sa_name        = "saaihubdev131014"
    container_registry_name = "craihubdev131014"
    ml_workspace_name = "mlw-ai-hub-dev-131014"
    application_insights_name = "appi-ai-hub-dev-131014"
    foundry_cognitive_account_name = "aifoundrydev131014"
    foundry_custom_subdomain_name = "aicustomsubdomaindev131014"
    project_name = "mcp_az_open_aidev131014"
    log_analytics_workspace_name = "law-ai-hub-dev-131014"
    cosmosdb_account_name = "cosmosdbaihubdev131014"
    cosmosdb_database_name = "db-ai-hub-dev-131014"
    cosmosdb_container_name = "container-ai-hub-dev-131014"
  }
}


 locals {
   l_az_keyvault = {
    name                        = local.l_values.key_vault_name
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
    name                     = local.l_values.sa_name
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
  source = "../../../mcp_resources/sa/storage_account"   
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.l_sa_tags
  storage_account  = local.l_storage_account
 }


locals {
  l_log_analytics_workspace = {
    name                = local.l_values.log_analytics_workspace_name
    location            = var.location
    sku                 = "PerGB2018"
    retention_in_days   = 30
  }
}


#log analytics workspace is a dependency for the ai hub module, so we need to create it before the ai hub module is created, but we can create it in the same main.tf file as the ai hub module, we just need to make sure that the log analytics workspace is created before the ai hub module is created by using the depends_on attribute in the ai hub module
module "m_ai_hub_la_ws" {
  source = "../../../mcp_resources/log_analy_workspace"
  resource_group_name = var.resource_group_name
  location            = var.location
  log_analytics_workspace = local.l_log_analytics_workspace
}


locals {
  l_application_insights = {
    name = local.l_values.application_insights_name
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
  source = "../../../mcp_resources/app_insight"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_insights = local.l_application_insights
  tags                = local.l_tags_application_insights
}


 
resource "azurerm_cognitive_account" "foundry" {
  name                = local.l_values.foundry_cognitive_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "AIServices"
  sku_name            = "S0"

  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name     = local.l_values.foundry_custom_subdomain_name
  dynamic_throttling_enabled = false
  local_auth_enabled         = true
  outbound_network_access_restricted = false
  project_management_enabled = true
}



resource "azurerm_cognitive_account_project" "project" {
  name                 = local.l_values.project_name
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = var.location 

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = "gpt-4o"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-11-20"
  }

  depends_on = [
    azurerm_cognitive_account.foundry
  ]
}




#--------------------------------------------------------------

# Cosmsod DB

#-------------------------------------------------------------

locals {
  tags_cd = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
  }
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = local.l_values.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  # Portal choice: Geo-Redundancy = Enable
  # enable_automatic_failover       = true
  automatic_failover_enabled = true

  # Portal choice: Multi-region Writes = Disable
  # enable_multiple_write_locations = false
  multiple_write_locations_enabled = false

  # Portal choice: Key-based Authentication = Enable
  local_authentication_disabled = false

  # Portal choice: Networking = All networks
  public_network_access_enabled = true

  # Portal choice: Minimum TLS Protocol = TLS 1.2
  minimal_tls_version = "Tls12"

  # NoSQL consistency; Session is the common default
  consistency_policy {
    consistency_level = "Session"
  }

  # Primary region
  geo_location {
    location          = var.location 
    failover_priority = 0
    zone_redundant    = false
  }

  # Secondary region for geo-redundancy / failover
  geo_location {
    location          = "West US"
    failover_priority = 1
    zone_redundant    = false
  }

  # Portal choice: Continuous (7 days)
  backup {
    type = "Continuous"
    tier = "Continuous7Days"
  }

  tags = local.tags_cd
}



locals {
  l_tags_db = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
  }
}


resource "azurerm_cosmosdb_sql_database" "db" {
  name                = local.l_values.cosmosdb_database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  }

resource "azurerm_cosmosdb_sql_container" "container" {
  name                = local.l_values.cosmosdb_container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_paths = ["/id"]

  # Provisioned throughput mode
  throughput = 400

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}