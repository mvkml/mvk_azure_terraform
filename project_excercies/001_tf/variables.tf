variable "client_id" {
  type        = string
  sensitive   = true
  description = "Azure Client ID"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Azure Client Secret"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
  default     = "vishnu-demo-rg"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "Central India"
}