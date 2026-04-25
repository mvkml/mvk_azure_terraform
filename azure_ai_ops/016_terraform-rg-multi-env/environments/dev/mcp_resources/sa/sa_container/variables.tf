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




variable "storage_accounts" {
  description = "List of storage accounts to create"

  type = list(object({
    Id                      = optional(number, 0)
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
    description                = optional(string, "For development and testing purposes")
    is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific storage accounts without modifying the code.
    is_hns_enabled           = optional(bool, false) # This flag can be used to enable or disable hierarchical namespace for the storage account, which is required for Gen2 storage accounts.
    containers                = optional(list(object({
      Id                      = optional(number, 0)
      sa_account_id            = optional(number, 0) # This can be used to link the container to its parent storage account if needed for reference.
      #this is optoinal because we can have storage accounts without containers or we might want to define containers separately. 
      #this will use rarely but it provides flexibility in how we structure our variables and resources.  
      name                  = string
      container_access_type = optional(string, "private")
      metadata              = optional(map(string), {})
      description             = optional(string, "For development and testing purposes")
      is_active             = optional(bool, true) # This flag can be used to enable or disable the creation of specific containers without modifying the code.
    
    
     blobs = optional(list(object({
      Id                      = optional(number, 0) # this is optional because we might have blobs that are not defined at the time of defining the container or we might want to define blobs separately.
      # not necessarily we will use this but it provides flexibility in how we structure our variables and resources.
      # This can be used to link the blob to its parent container if needed for reference and organization, especially when dealing with multiple blobs and containers.
      container_id             = optional(number, 0) # This can be used to link the blob to its parent container if needed for reference.
       #this is optoinal because we can have blobs that are not defined at the time of defining the container or we might want to define blobs separately.  
       #this will use rarely but it provides flexibility in how we structure our variables and resources.
      sa_account_id            = optional(number, 0) # This can be used to link the blob to its parent storage account if needed for reference.
      container_name           = string # This is required to link the blob to its parent container.
      name                     = string
      type                     = optional(string, "Block")
      source                   = optional(string, "documents/default_file/default_file.txt")
      pattern                  = optional(string, "*.*")
      blob_items               = optional(list(string), [])
      description              = optional(string, "For development and testing purposes")
      is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific blobs without modifying the code.
    })), [])
    
    
    })), [])

   

  })# object
  
  )
}