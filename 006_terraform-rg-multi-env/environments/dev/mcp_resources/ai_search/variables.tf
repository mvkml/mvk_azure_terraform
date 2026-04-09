variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "ai_search_tags" {
  type    = map(string)
  default = {}
}

variable "ai_search_services" {
  type = map(object({
    name            = string
    sku             = string
    replica_count   = number
    partition_count = number
    is_active       = bool
  }))
}