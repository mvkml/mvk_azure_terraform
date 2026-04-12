

variable "az_keyvault" {
  type = object({
    # optional with 0 default value 
    Id                = optional(number, 0)
    name              = string
    location           = string 
    tenant_id         = string
    object_id         = string
    sku_name          = string
    soft_delete_enabled = bool
    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled = bool
    description         = optional(string, "")
    is_active           = optional(bool, true)
  })

}

variable "az_keyvault_values" {
  type = list(object({
    # optional with 0 default value 
    Id                = optional(number, 0)
    name              = string
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