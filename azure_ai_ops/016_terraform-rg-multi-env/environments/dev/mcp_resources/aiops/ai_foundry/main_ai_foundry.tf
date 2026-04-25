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


 
resource "azurerm_cognitive_account" "foundry" {

  name                = local.l_names.foundry_cognitive_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "AIServices"
  sku_name            = "S0"

  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name     = local.l_names.foundry_custom_subdomain_name
  dynamic_throttling_enabled = false
  local_auth_enabled         = true
  outbound_network_access_restricted = false
  project_management_enabled = true
}



resource "azurerm_cognitive_account_project" "project" {

  name                 = local.l_names.project_name
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

resource "azurerm_cognitive_deployment" "text_embedding_3_small" {

  name                 = "text-embedding-3-small"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "Standard"
    capacity = 1
  }

  model {
    format  = "OpenAI"
    name    = "text-embedding-3-small"
    version = "1"
  }

  depends_on = [
    azurerm_cognitive_account.foundry
  ]
}

