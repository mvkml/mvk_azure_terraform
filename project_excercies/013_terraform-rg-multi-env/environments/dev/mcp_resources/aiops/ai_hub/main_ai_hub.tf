locals {
  l_values = {
    key_vault_name = "kvaihubdev122132"
    sa_name        = "saaihubdev122132"
    container_registry_name = "craihubdev122132"
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
  # can  you confirm is clientid or object id should be used here for the access policy of the key vault, I have seen both being used in different examples, but I want to make sure we are using the correct one for our use case
  tags                = local.l_sa_tags
  storage_account  = local.l_storage_account
 }

# Container registry for AI Hub
#-----------------------------------

locals {
  l_container_registry = {
    name                = local.l_values.container_registry_name
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = "Basic"
    admin_enabled       = true
  }
}

locals {
  l_tags_container_registry = {
    "Project"     = "AI Hub"
    "Environment" = "Development"
    "Owner"       = "Vishnu Kiran M"
    "CostCenter"  = "AI-001"
  }
}


module "m_ai_hub_consumer_registry" {
   source = "../../../mcp_resources/aiops/ai_container_registry"
   resource_group_name = var.resource_group_name
   location            = var.location
   container_registry  = local.l_container_registry
   tags                = local.l_tags_container_registry
 }
