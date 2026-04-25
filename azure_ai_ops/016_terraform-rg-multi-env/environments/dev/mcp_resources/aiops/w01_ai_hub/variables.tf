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


variable environment {
  type        = string
  default     = "dev"
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
  default = []

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
    managed_by                 = "VISHNU KIRAN M"
    is_active              = true
    description           = "The context or purpose of the application, used in resource naming conventions"
  }
  description = "The context or purpose of the application, used in resource naming conventions"
}
