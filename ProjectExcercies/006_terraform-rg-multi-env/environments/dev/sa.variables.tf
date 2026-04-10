variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}

variable "storage_accounts" {
  description = "List of storage accounts to create"

  type = list(object({
    
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
    description                = optional(string, "For development and testing purposes")
    is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of specific storage accounts without modifying the code.
    
    containers                = optional(list(object({
      name                  = string
      container_access_type = optional(string, "private")
      metadata              = optional(map(string), {})
      description             = optional(string, "For development and testing purposes")
      is_active             = optional(bool, true) # This flag can be used to enable or disable the creation of specific containers without modifying the code.
    })), [])

  })# object
  
  )
}