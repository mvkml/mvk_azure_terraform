# Terraform Error Fix: Invalid for_each argument (list of object)

## Why this error happens

`for_each` does not accept a `list(object)` directly.

Terraform requires `for_each` to be one of:

- a map
- a set of strings

Your variable `var.storage_accounts` is a list of objects, so this fails:

```hcl
for_each = var.storage_accounts
```

---

## Correct solution

Convert the list into a map using a unique key (storage account name is typically a good key if unique).

```hcl
resource "azurerm_storage_account" "storage_accounts" {
	for_each = {
		for sa in var.storage_accounts :
		sa.name => sa
	}

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
```

---

## Optional: deploy only active accounts

If your object has `is_active`, you can filter during map creation:

```hcl
for_each = {
	for sa in var.storage_accounts :
	sa.name => sa
	if sa.is_active
}
```

---

## Important note

`sa.name` must be unique. If duplicates exist, Terraform will raise a duplicate key error.

---

## Validate after update

```bash
terraform validate
terraform plan
```
*** End Patch
 