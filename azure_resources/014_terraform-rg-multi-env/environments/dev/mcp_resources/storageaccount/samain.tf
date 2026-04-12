# Name : sa_main.tf
# Description: This file contains the main Terraform code for creating Azure Storage Accounts, Containers, and Blobs based on the variables defined in sa.variables.tf. It uses conditional logic to create resources only if they are marked as active, allowing for flexible configuration and management of storage resources in the development environment.

# Author: VISHNU KIRAN M  
# End-to-End AI, Cloud, Big Data, IoT & Embedded Solution Designer
# I design and deliver end-to-end AI solutions across the full lifecycle, from strategy and architecture to deployment, optimization, and measurable business outcomes. I am an expert in IoT solution design with embedded components, building integrated systems that connect edge devices, cloud platforms, and data/AI pipelines for scalable, production-grade enterprise solutions.
# ViKi-Pedia


#------------------- storage account creation ---------------------
#---------------------------------------------------------------
# This code snippet defines the creation of Azure Storage Accounts, Containers, and Blobs using Terraform. It utilizes variables to allow for flexible configuration and conditional resource creation based on the is_active flag. The storage accounts are created first, followed by the containers and blobs, which are linked to their respective parent resources for organization and reference.
resource "azurerm_storage_account" "storage_accounts" {
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

	tags = var.common_tags
}



#--------- can I have blokc ---------------------
#------------------------------------------------
# Yes, you can have blocks in Terraform. Blocks are used to define resources, data sources, modules, and other configurations in Terraform. They allow you to specify the properties and settings for the resources you want to create or manage. In the provided code snippet, there are blocks for defining storage accounts, containers, and blobs in Azure using the azurerm provider. Each block contains specific attributes and settings relevant to the resource being defined.

// this is related to container
locals {
	active_container_group = flatten([
		for sa in var.storage_accounts : [
			for container in sa.containers : {
				storage_account_name  = sa.name
				container_name        = container.name
				container_access_type = container.container_access_type
				metadata              = container.metadata
			} if container.is_active
		] if sa.is_active
	])
}


resource "azurerm_storage_container" "containers" {
  for_each = { for idx, container in local.active_container_group : "${container.storage_account_name}-${container.container_name}" => container }
  
  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_accounts[each.value.storage_account_name].name #each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata

}
#---------------------------------------------------  




#--------- blobs creation  ---------------------
#-----------------------------------------------
# blobs are the actual data stored in the storage account, and they can be organized within containers. In this code snippet, we are defining a local variable active_blob_groups that flattens the list of storage accounts, containers, and blobs to create a single list of active blobs. Each blob is associated with its parent storage account and container for reference.
locals {
  active_blob_groups = flatten([
    for sa in var.storage_accounts : [
      for container in sa.containers : [
        for blob in container.blobs : {
          storage_account_name = sa.name
          container_name       = container.name
          blob_name            = blob.name
          blob_type            = blob.type
          blob_source          = blob.source
          blob_pattern         = blob.pattern
          blob_items           = [ 
            for item in fileset("${path.root}/${blob.source}", blob.pattern) :
            item 
            # This condition checks if the blob_items list is empty or if the current item is included in the blob_items list, allowing for flexible blob management based on specific items or patterns.
             ] # This will create a list of files that match the specified pattern in the source directory, allowing for flexible blob management based on file patterns.
        } if blob.is_active
      ] if container.is_active
    ] if sa.is_active
  ])
}


locals {
  active_blobs = flatten([
    for blob_group in local.active_blob_groups :
    length(blob_group.blob_items) > 0 ?
    [
      for blob_item in blob_group.blob_items : {
        storage_account_name = blob_group.storage_account_name
        container_name       = blob_group.container_name
        blob_name            = "${blob_group.blob_name}/${blob_item}"
        blob_type            = blob_group.blob_type
        blob_item_source     = "${path.root}/${blob_group.blob_source}/${blob_item}"
      }
    ]
    :
    [
      {
        storage_account_name = blob_group.storage_account_name
        container_name       = blob_group.container_name
        blob_name            = blob_group.blob_name
        blob_type            = blob_group.blob_type
        blob_item_source     = "${path.root}/${blob_group.blob_source}"
      }
    ]
  ])
}


resource "azurerm_storage_blob" "blobs" {
  for_each = {
    for blob in local.active_blobs :
    "${blob.storage_account_name}-${blob.container_name}-${blob.blob_name}" => blob
  }

  name = each.value.blob_name

  storage_account_name = azurerm_storage_account.storage_accounts[
    each.value.storage_account_name
  ].name

  storage_container_name = azurerm_storage_container.containers[
    "${each.value.storage_account_name}-${each.value.container_name}"
  ].name

  type   = each.value.blob_type
  source = each.value.blob_item_source
}
#---------------------------------------------------







