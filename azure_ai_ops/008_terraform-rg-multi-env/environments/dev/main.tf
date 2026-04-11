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
 rg_name = "${var.client_name}-${var.repository_short_name}-${var.project_name}-${var.location_id}-${var.resource_type}-${var.environment_code}"
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


module "storageaccount" {
  source = "./mcp_resources/storageaccount"

  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  common_tags         = local.common_tags
  storage_accounts = var.storage_accounts
}


module "ai_search" {
  source = "./mcp_resources/aiops/ai_search"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  ai_search_tags      = local.common_tags
  ai_search_services  = var.ai_search_services 
}

