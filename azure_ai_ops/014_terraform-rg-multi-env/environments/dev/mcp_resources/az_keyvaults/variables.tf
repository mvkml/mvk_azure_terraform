variable tags {
  type        = map(string)
  default     = {}
  description = "description"
}


variable resource_group_name {
  type        = string
  default     = ""
  description = "description"
}

variable  location {
  type        = string
  default     = ""
  description = "description"
}

variable tenant_id {
  type        = string
  default     = ""
  description = "description"
} 

variable object_id {
  type        = string
  default     = ""
  description = "description"
}



variable "az_keyvault_values" {
  type = list(object({
    # optional with 0 default value 
    Id                = optional(number, 0)
    name     = string
    location           = string
    tenant_id         = string
    object_id         = string
    sku_name          = string
    soft_delete_enabled = bool
    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled = bool
    description         = optional(string, "")
    is_active           = optional(bool, true)
  }))

}