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

variable "application_insights" {
    type = object({
        name                     = optional(string, "mlw-aihub")
        location                 = optional(string, "eastus")
        resource_group_name      = optional(string, "")
        application_type         = optional(string, "web")
        description              = optional(string, "Azure Application Insights for AI Hub")
        is_active                = optional(bool, true) # This flag can be used to enable or disable the creation of the Application Insights without modifying the code.
    })

}