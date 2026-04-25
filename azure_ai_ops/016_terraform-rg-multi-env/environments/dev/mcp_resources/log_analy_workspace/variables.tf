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


variable log_analytics_workspace {
  
  type        = object({
    name                = string
    location            = optional(string, "")
    resource_group_name = optional(string, "")
    sku                 = optional(string, "")
    retention_in_days   = optional(number, 30)
    description = optional(string, "Log Analytics Workspace configuration")
    is_active = optional(bool, true)
  })
  default     = {
    name                = "law-ai-hub-dev-122251"
    location            = "East US"
    resource_group_name = "rg-ai-hub-dev"
    sku                 = "Free"
    retention_in_days   = 30
    description         = "Log Analytics Workspace configuration"
    is_active           = true
}
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
    managed_by                 = optional(string, "VISHNU KIRAN M")
    is_active                = optional(bool, true)
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
    is_active              = true
    managed_by                 = "VISHNU KIRAN M"
    description           = "The context or purpose of the application, used in resource naming conventions"
  }
  description = "The context or purpose of the application, used in resource naming conventions"
}
