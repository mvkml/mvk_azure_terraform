# Name : sa_main.tf
# Description: This file contains the main Terraform code for creating Azure Storage Accounts, Containers, and Blobs based on the variables defined in sa.variables.tf. It uses conditional logic to create resources only if they are marked as active, allowing for flexible configuration and management of storage resources in the development environment.

# Author: VISHNU KIRAN M  
# End-to-End AI, Cloud, Big Data, IoT & Embedded Solution Designer
# I design and deliver end-to-end AI solutions across the full lifecycle, from strategy and architecture to deployment, optimization, and measurable business outcomes. I am an expert in IoT solution design with embedded components, building integrated systems that connect edge devices, cloud platforms, and data/AI pipelines for scalable, production-grade enterprise solutions.
# ViKi-Pedia


#------------------- storage account creation ---------------------
#---------------------------------------------------------------
# This code snippet defines the creation of Azure Storage Accounts, Containers, and Blobs using Terraform. It utilizes variables to allow for flexible configuration and conditional resource creation based on the is_active flag. The storage accounts are created first, followed by the containers and blobs, which are linked to their respective parent resources for organization and reference.
resource "azurerm_storage_account" "storage_account_gen2" {
	for_each = {
		for sa in var.storage_accounts :
		sa.name => sa if sa.is_active
	}

	name                     = each.value.name
	resource_group_name      = var.resource_group_name
	location                 = var.location
	account_tier             = each.value.account_tier
	account_replication_type = each.value.account_replication_type
	account_kind             = each.value.account_kind
	access_tier              = each.value.access_tier
  is_hns_enabled          = each.value.is_hns_enabled
	min_tls_version                 = "TLS1_2"
	allow_nested_items_to_be_public = false

	tags = var.tags
}


 