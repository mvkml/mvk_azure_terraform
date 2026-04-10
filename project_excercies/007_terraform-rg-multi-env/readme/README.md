# Azure Storage Account Resource - Step-by-Step Explanation

This document explains the following Terraform block in simple steps.

resource "azurerm_storage_account" "storage_accounts" {
	for_each = var.storage_accounts

	name                     = each.value.name
	resource_group_name      = var.resource_group_name
	location                 = var.location
	account_tier             = each.value.account_tier
	account_replication_type = each.value.account_replication_type
	account_kind             = each.value.account_kind
	access_tier              = each.value.access_tier

	min_tls_version                 = "TLS1_2"
	allow_nested_items_to_be_public = false

	tags = var.common_tags
}

## 1. Resource Declaration

- resource "azurerm_storage_account" "storage_accounts"
- azurerm_storage_account is the Azure resource type.
- storage_accounts is the local Terraform name used to reference these resources.

## 2. Loop Through Multiple Accounts

- for_each = var.storage_accounts
- Terraform creates one storage account for each item in var.storage_accounts.
- If var.storage_accounts has 3 entries, Terraform creates 3 storage accounts.

## 3. Per-Account Values

These values come from each item in the loop:

- name = each.value.name
- account_tier = each.value.account_tier
- account_replication_type = each.value.account_replication_type
- account_kind = each.value.account_kind
- access_tier = each.value.access_tier

Meaning:

- each.value refers to the current storage account object.
- This lets every account have its own name and configuration.

## 4. Shared Values for All Accounts

These are common for all created storage accounts:

- resource_group_name = var.resource_group_name
- location = var.location
- tags = var.common_tags

Meaning:

- All storage accounts are created in the same resource group and region.
- All storage accounts receive the same common tags.

## 5. Security Defaults

- min_tls_version = "TLS1_2"
- Forces clients to use TLS 1.2 or higher.

- allow_nested_items_to_be_public = false
- Prevents nested items (such as blob containers and blobs) from being publicly exposed by default.

## 6. Overall Behavior Summary

This block is a reusable multi-environment pattern:

- Shared settings are defined once using variables.
- Account-specific settings are provided per entry in var.storage_accounts.
- Security baseline is enforced for every account.

## 7. Example Shape of var.storage_accounts

Example input structure:

storage_accounts = {
	appsa = {
		name                     = "appstgdev001"
		account_tier             = "Standard"
		account_replication_type = "LRS"
		account_kind             = "StorageV2"
		access_tier              = "Hot"
	}
	logs = {
		name                     = "logsstgdev001"
		account_tier             = "Standard"
		account_replication_type = "GRS"
		account_kind             = "StorageV2"
		access_tier              = "Cool"
	}
}

With this example, Terraform will create two storage accounts: one for app data and one for logs.
 