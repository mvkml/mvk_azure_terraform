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
 

variable "container_registry" {
   type = object({
     admin_enabled = optional(bool, true)
     resource_group_name = optional(string, "")
     location            = optional(string, "")
     name          = optional(string, "aihubcontainerreg")
     sku           = optional(string, "Basic")
   })
}


 