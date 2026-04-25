variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "location" {
  type = string
}

variable "env_names" {
  type = list(string)
}

variable "managedby" {
  type        = string
  default     = ""
  description = " Tag to indicate the tool managing the resources, e.g., 'terraform'"
}

variable "location_id" {
  type        = string
  default     = ""
  description = "Code representing the location, used in resource naming conventions"
}


variable "environment" {
  type        = string
  default     = ""
  description = "The deployment environment, e.g., 'dev', 'qa', 'uat', 'prod'"
}


variable "client_name" {
  type        = string
  default     = ""
  description = "The name of the client or organization, used in resource naming conventions"
}


variable "repository_short_name" {
  type        = string
  default     = ""
  description = "The short name of the repository, used in resource naming conventions"
}

variable "resource_type" {
  type        = string
  default     = ""
  description = "The type of the resource, used in resource naming conventions  "
}


variable "environment_code" {
  type        = string
  default     = ""
  description = "The code representing the environment, used in resource naming conventions"
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
    environment_version    = optional(string, "04181656")
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
    environment_version    = "04181656"
    is_active              = true
    description           = "The context or purpose of the application, used in resource naming conventions"
  }
  description = "The context or purpose of the application, used in resource naming conventions"
}
