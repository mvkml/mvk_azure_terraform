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


