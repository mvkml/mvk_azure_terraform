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