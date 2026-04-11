variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}


variable "storage_accounts" {
  description = "List of storage accounts to create"

  type = list(object({
    #this is optional because we might have storage accounts that are not defined at the time of defining the variable or we might want to define storage accounts separately.
    Id                      = optional(number, 0)
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
    description                = optional(string, "For development and testing purposes")
    is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific storage accounts without modifying the code.
    
    containers                = optional(list(object({
      # this is optoinal because we can have storage accounts without containers or we might want to define containers separately. 
      # this will use rarely but it provides flexibility in how we structure our variables and resources.
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
      name                     = string # example: "foldername/myblob.txt"
      type                     = optional(string, "Block")
      source                   = optional(string, "documents/default_file/default_file.txt") # This is the local path to the file that will be uploaded as a blob. It can be made optional with a default value if needed.
      pattern                  = optional(string, "*.*") # This can be used to specify a pattern for matching files to upload as blobs, providing flexibility in how blobs are defined and managed.
      blob_items               = optional(list(string), []) # This can be used to specify individual blob items within the container, providing flexibility in how blobs are defined and managed.
      description              = optional(string, "For development and testing purposes")
      is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific blobs without modifying the code.
    })), [])
    
    
    })), [])

   

  })# object
  
  )
}