# variable tags {
#   type        = map(string)
#   default     = {}
#   description = "description"
# }


# variable resource_group_name {
#   type        = string
#   default     = ""
#   description = "description"
# }

# variable  location {
#   type        = string
#   default     = ""
#   description = "description"
# }

# variable "ml_workspace" {
#     type = object({
#         name                     = optional(string, "mlw-aihub")
#         location                 = optional(string, "eastus")
#         resource_group_name      = optional(string, "")
#         application_insights_id  = optional(string, "")
#         key_vault_id             = optional(string, "")
#         storage_account_id       = optional(string, "")
#         container_registry_id    = optional(string, "")
#         description              = optional(string, "Azure Machine Learning Workspace for AI Hub")
#         is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of the ML workspace without modifying the code.
#     })

# }





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
