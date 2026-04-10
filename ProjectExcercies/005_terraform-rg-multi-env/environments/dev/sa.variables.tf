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
  }))
}