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
