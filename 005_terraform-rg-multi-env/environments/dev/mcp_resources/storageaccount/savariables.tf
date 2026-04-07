variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all storage accounts"
  default     = {}
}

variable "storage_accounts" {
  description = "Map of storage account configurations"

  type = map(object({
    name                     = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    account_kind             = optional(string, "StorageV2")
    access_tier              = optional(string, "Hot")
  }))
}