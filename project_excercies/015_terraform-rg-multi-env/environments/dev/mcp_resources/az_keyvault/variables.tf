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


variable "az_keyvault" {
    type = object({Id                = optional(number, 0)
    name              = optional(string, "")
    location           = optional(string, "")
    tenant_id         = optional(string, "")
    object_id         = optional(string, "")
    sku_name          = optional(string, "standard")
    soft_delete_enabled = optional(bool, true)
    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled = optional(bool, false)
    description         = optional(string, "")
    is_active           = optional(bool, true)
})
}