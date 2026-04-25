variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all storage accounts"
  default     = {}
}



variable "storage_account" {
   type = object({
    Id                      = optional(number, 0)
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
    description                = optional(string, "For development and testing purposes")
    is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific storage accounts without modifying the code.
    is_hns_enabled           = optional(bool, false) # This flag can be used to enable or disable hierarchical namespace for the storage account, which is required for Gen2 storage accounts.
})
  }


  
variable app_context {
  type        = object({
    project_name           = optional(string, "mcp-ai")
    location_id            = optional(string, "")
    location               = optional(string, "Central US")
    secondary_location       = optional(string, "West US")
    environment            = optional(string, "dev")
    client_name            = optional(string, "etna")
    repository_short_name  = optional(string, "ubcliams")
    resource_type          = optional(string, "")
    environment_code       = optional(string, "")
    environment_version    = optional(string, "")
    is_active                = optional(bool, true)
    managed_by                 = optional(string, "VISHNU KIRAN M")
    description               = optional(string, "The context or purpose of the application, used in resource naming conventions")
    
  })
  default     = {
    project_name           = ""
    location_id            = ""
    location                = ""
    secondary_location      = ""
    environment            = "dev"
    client_name            = ""
    repository_short_name  = ""
    resource_type          = ""
    environment_code       = ""
    environment_version    = ""
    is_active              = true
    managed_by                 = "VISHNU KIRAN M"
    description           = "The context or purpose of the application, used in resource naming conventions"
  }
  description = "The context or purpose of the application, used in resource naming conventions"
}
