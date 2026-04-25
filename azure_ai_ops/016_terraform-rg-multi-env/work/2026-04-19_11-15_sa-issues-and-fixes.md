# Storage Account Issues & Fixes
**Date:** 2026-04-19 11:15  
**File:** `environments/dev/mcp_resources/sa/sa_multi_version/main_sa_multi_version.tf`

---

## Issue 1 — Error: 404 Storage Account Not Found

### Error Message
```
Error: encoding Storage Account (Subscription: "ce658dab-cae6-43c7-aa43-3f8c2ea7f68f"
Resource Group Name: "etna-ubcliams-mcp-ai-cus-rg-041905"
Storage Account Name: "saetnahrcus27"): retrieving static website properties...
unexpected status 404 (404 The specified resource does not exist.)
```

### Root Cause
- The resource group name was changed → Terraform destroyed the old RG and all resources in it
- The old storage account `saetnahrcus27` (without version suffix) still exists in the **Terraform state file**
- When Terraform runs `plan`, it tries to refresh the old state by looking up `saetnahrcus27` in Azure → Azure returns 404 because it no longer exists
- The new code generates name `saetnahrcus27041910` (base name + environment_version), so Terraform treats them as two different resources

### Why This Happened
The `storage_accounts_versioned` local now appends `environment_version` to the name:
```hcl
locals {
  storage_accounts_versioned = [
    for sa in var.storage_accounts : merge(sa, {
      name = "${sa.name}${local.l_evn_version}"   # "saetnahrcus27" + "041910" = "saetnahrcus27041910"
    })
  ]
}
```
The old resource in state is keyed as `"saetnahrcus27"` but the new `for_each` key is `"saetnahrcus27041910"`.

### Fix
Remove the stale resource from Terraform state before applying:
```bash
cd environments/dev

terraform state rm 'module.m_hr02_ai_search.module.m_sa_multi_version.azurerm_storage_account.storage_accounts["saetnahrcus27"]'
```
After this, `terraform plan` will no longer error on the missing resource.

---

## Issue 2 — Warning: `storage_account_name` Deprecated

### Warning Message
```
Warning: Argument is deprecated
  with module.m_hr02_ai_search.module.m_sa_multi_version.azurerm_storage_container.containers["saetnahrcus27041910-hr-process"],
  on mcp_resources\sa\sa_multi_version\main_sa_multi_version.tf line 60

the `storage_account_name` property has been deprecated in favour of `storage_account_id`
and will be removed in version 5.0 of the Provider.
```

### Root Cause
`azurerm` provider v4.x deprecated `storage_account_name` on both:
- `azurerm_storage_container` (line 60)
- `azurerm_storage_blob` (line 122)

These will **break** when provider upgrades to v5.0.

### Fix — azurerm_storage_container (line 56–63)

**Before:**
```hcl
resource "azurerm_storage_container" "containers" {
  for_each = { for idx, container in local.active_container_group : "${container.storage_account_name}-${container.container_name}" => container }

  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_accounts[each.value.storage_account_name].name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}
```

**After:**
```hcl
resource "azurerm_storage_container" "containers" {
  for_each = { for idx, container in local.active_container_group : "${container.storage_account_name}-${container.container_name}" => container }

  name                  = each.value.container_name
  storage_account_id    = azurerm_storage_account.storage_accounts[each.value.storage_account_name].id
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}
```

### Fix — azurerm_storage_blob (line 115–126)

**Before:**
```hcl
resource "azurerm_storage_blob" "blobs" {
  ...
  storage_account_name   = azurerm_storage_account.storage_accounts[each.value.storage_account_name].name
  storage_container_name = azurerm_storage_container.containers["${each.value.storage_account_name}-${each.value.container_name}"].name
  ...
}
```

**After:**
```hcl
resource "azurerm_storage_blob" "blobs" {
  ...
  storage_account_id     = azurerm_storage_account.storage_accounts[each.value.storage_account_name].id
  storage_container_name = azurerm_storage_container.containers["${each.value.storage_account_name}-${each.value.container_name}"].name
  ...
}
```

---

## Apply Order

1. Run `terraform state rm` command (Issue 1 fix) — removes stale state
2. Update `main_sa_multi_version.tf` with `storage_account_id` (Issue 2 fix)
3. Run `terraform plan` — should show clean plan with no errors or warnings
4. Run `terraform apply`

---

## Terraform Plan Summary (before fixes)
```
Plan: 6 to add, 0 to change, 3 to destroy
```
- **3 to destroy** — old resources (SA, container, blob) with name `saetnahrcus27` from old resource group
- **6 to add** — new resource group + new SA/container/blob with versioned name + AI search resources
