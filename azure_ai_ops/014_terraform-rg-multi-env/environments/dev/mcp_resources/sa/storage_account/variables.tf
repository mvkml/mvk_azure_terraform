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