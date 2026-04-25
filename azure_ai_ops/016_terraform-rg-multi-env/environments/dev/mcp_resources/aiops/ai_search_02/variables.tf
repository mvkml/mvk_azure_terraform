variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "ai_search_tags" {
  type    = map(string)
  default = {}
}

variable "ai_search_services" {
  type = map(object({
    name            = string
    sku             = string
    replica_count   = number
    partition_count = number
    is_active       = bool
    location        = optional(string, "eastus")
  }))
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
