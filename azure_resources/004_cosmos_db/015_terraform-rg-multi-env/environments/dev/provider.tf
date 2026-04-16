# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=4.1.0"
#     }
#   }
# }

terraform {
  required_version = ">= 1.12, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  resource_provider_registrations = "none"

  client_id       = var.client_id // this is the client id of the service principal, not the client id of the subscription
  client_secret   = var.client_secret // this is the client secret of the service principal, not the client secret of the subscription
  tenant_id       = var.tenant_id // this is the tenant id of the service principal, not the tenant id of the subscription
  subscription_id = var.subscription_id
}