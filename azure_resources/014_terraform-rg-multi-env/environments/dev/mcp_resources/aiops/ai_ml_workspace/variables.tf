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

variable "ml_workspace" {
    type = object({
        name                     = optional(string, "mlw-aihub")
        location                 = optional(string, "eastus")
        resource_group_name      = optional(string, "")
        application_insights_id  = optional(string, "")
        key_vault_id             = optional(string, "")
        storage_account_id       = optional(string, "")
        container_registry_id    = optional(string, "")
        description              = optional(string, "Azure Machine Learning Workspace for AI Hub")
        is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of the ML workspace without modifying the code.
    })

}