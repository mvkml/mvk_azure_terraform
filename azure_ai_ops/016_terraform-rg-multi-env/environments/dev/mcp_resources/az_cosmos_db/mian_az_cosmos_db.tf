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


  name                = local.l_names.cosmosdb_account_name
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
  name                = local.l_names.cosmosdb_database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  }

resource "azurerm_cosmosdb_sql_container" "container" {
  name                = local.l_names.cosmosdb_container_name
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






# resource "azurerm_cosmosdb_account" "az_cd_account" {
#   name = var.az_cd.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   offer_type          = var.az_cd.offer_type
#   kind               = var.az_cd.kind
#   enable_automatic_failover = var.az_cd.enable_automatic_failover
#   enable_multiple_write_locations = var.az_cd.enable_multiple_write_locations
#   local_authentication_disabled = var.az_cd.local_authentication_disabled 
#   public_network_access_enabled = var.az_cd.public_network_access_enabled
#   minimal_tls_version = var.az_cd.minimal_tls_version
#   consistency_policy {
#     consistency_level = var.az_cd.consistency_policy.consistency_level
#   }
#   geo_location {
#     location          = var.az_cd.geo_location.location
#     failover_priority = var.az_cd.geo_location.failover_priority
#     zone_redundant    = var.az_cd.geo_location.zone_redundant
#   }
#   secondary_geo_location {
#     location          = var.az_cd.secondary_geo_location.location
#     failover_priority = var.az_cd.secondary_geo_location.failover_priority
#     zone_redundant    = var.az_cd.secondary_geo_location.zone_redundant
#   }
#   backup {
#     type = var.az_cd.backup.type
#     tier = var.az_cd.backup.tier
#   }
#   tags = var.tags_az_cd
# }



# resource "azurerm_cosmosdb_sql_database" "az_cd_sqldb" {
#   name                = var.name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   account_name        = azurerm_cosmosdb_account.az_cd_account.name
#   tags                = var.tags_az_cd_sql_db
# }

# resource "azurerm_cosmosdb_sql_container" "az_cd_sql_container" {
#   name                = var.name
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   account_name        = azurerm_cosmosdb_account.az_cd_account.name
#   database_name       = azurerm_cosmosdb_sql_database.az_cd_sqldb.name
#   partition_key_paths = var.az_cd_sql_container.partition_key_paths
#   tags                = var.tags_az_cd_sql_container
# }

