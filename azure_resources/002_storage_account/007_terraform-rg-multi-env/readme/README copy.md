# Azure Storage Containers with Conditional Filtering - In-Depth Explanation

This document explains advanced Terraform code that creates storage containers only when they are marked as active. It uses nested loops and filtering.

## The Code

```hcl
locals {
  active_conatiner_map = {
    for item in flatten([
      for sa in var.storage_accounts : if sa.is_active => [
        for container in sa.containers : if container.is_active => {
          storage_account_name = sa.name
          container_name       = container.name
          container_access_type = container.container_access_type
          metadata              = container.metadata
        }
      ]])
  }
}

resource "azurerm_storage_container" "containers" {
  for_each = { for k, v in local.active_conatiner_map : k => v }

  name                  = each.value.container_name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}
```

---

## Part 1: Understanding the Locals Block

### What is `locals { }`?

- Locals are internal Terraform variables created within your configuration.
- They are computed once and reused throughout the configuration.
- They allow complex logic without needing separate variable files.

### What is `active_conatiner_map`?

This is the name of the local variable that will hold a map of all active containers filtered from all active storage accounts.

---

## Part 2: Breaking Down the Nested Loops

This is the hardest part. Let's unwrap it step by step.

### Step A: Outermost Loop - for item in flatten([...])

```hcl
for item in flatten([...])
```

- The `flatten()` function takes a nested list and flattens it into a single-level list.
- This converts the nested container structures into a flat list of container objects.
- Example: `[[{container1}, {container2}], [{container3}]]` becomes `[{container1}, {container2}, {container3}]`

### Step B: First Inner Loop - Iterate Over Storage Accounts

```hcl
for sa in var.storage_accounts : if sa.is_active => [...]
```

Meaning:
- Loop through each storage account in `var.storage_accounts`
- `sa` is the current storage account
- `if sa.is_active =>` filters to **only active storage accounts** (where is_active = true)
- The `=>` arrow means "for each match, create this"

Example:
```
If var.storage_accounts = {
  "prod_storage" => { name = "prodsa001", is_active = true, containers = [...] }
  "dev_storage"  => { name = "devsa001", is_active = false, containers = [...] }
}
```
Only `prod_storage` enters the next loop because `is_active = true`.

### Step C: Second Inner Loop - Iterate Over Containers

```hcl
for container in sa.containers : if container.is_active => {
  storage_account_name = sa.name
  container_name       = container.name
  container_access_type = container.container_access_type
  metadata              = container.metadata
}
```

Meaning:
- For the current storage account `sa`, loop through its containers
- `container` is the current container
- `if container.is_active =>` filters to **only active containers** (where is_active = true)
- For each active container, create an object with 4 fields

Example:
```
If sa.containers = [
  { name = "logs", is_active = true, container_access_type = "Private", metadata = {} }
  { name = "backup", is_active = false, container_access_type = "Private", metadata = {} }
]
```
Only the `logs` container is selected because `is_active = true`.

---

## Part 3: The Flattening Process

### Why Flatten?

The nested loops create a nested list structure like this:

```
[
  [  // From prod_storage (active)
    { storage_account_name: "prodsa001", container_name: "logs", ... },
    { storage_account_name: "prodsa001", container_name: "data", ... }
  ],
  [  // From staging_storage (active)
    { storage_account_name: "stagingsa001", container_name: "archive", ... }
  ]
]
```

The `flatten()` function converts this into a single flat list:

```
[
  { storage_account_name: "prodsa001", container_name: "logs", ... },
  { storage_account_name: "prodsa001", container_name: "data", ... },
  { storage_account_name: "stagingsa001", container_name: "archive", ... }
]
```

### The Outer for_each Loop

```hcl
for item in flatten([...])
```

- Now loop through this flat list
- `item` is each container object
- Create an entry in the map for each container

### Building the Map

The final result is a map (dictionary):

```hcl
active_conatiner_map = {
  "0" => { storage_account_name: "prodsa001", container_name: "logs", ... },
  "1" => { storage_account_name: "prodsa001", container_name: "data", ... },
  "2" => { storage_account_name: "stagingsa001", container_name: "archive", ... }
}
```

The keys are automatically generated indices (0, 1, 2, ...).

---

## Part 4: The Resource Block

### Creating Containers from the Locals Map

```hcl
resource "azurerm_storage_container" "containers" {
  for_each = { for k, v in local.active_conatiner_map : k => v }

  name                  = each.value.container_name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}
```

Breaking this down:

1. **for_each = { for k, v in local.active_conatiner_map : k => v }**
   - Converts the local map into a for_each-compatible map
   - `k` = key (index: 0, 1, 2, ...)
   - `v` = value (the container object)
   - Result: iterates over each active container

2. **for each container created:**
   - `name` = the container name (e.g., "logs")
   - `storage_account_name` = the parent storage account name (e.g., "prodsa001")
   - `container_access_type` = access level (Private, Blob, Container)
   - `metadata` = custom metadata tags

3. **Result:**
   Terraform creates one `azurerm_storage_container` resource for each active container in each active storage account.

---

## Part 5: Overall Flow - Simple Example

### Input

```hcl
var.storage_accounts = {
  "prod" => {
    name = "prodsa"
    is_active = true
    containers = [
      { name = "logs", is_active = true, container_access_type = "Private", metadata = { env = "prod" } }
      { name = "backup", is_active = false, container_access_type = "Private", metadata = {} }
    ]
  }
  "dev" => {
    name = "devsa"
    is_active = false
    containers = [
      { name = "test", is_active = true, container_access_type = "Private", metadata = { env = "dev" } }
    ]
  }
}
```

### Processing

1. Filter storage accounts: Only `prod` is active (is_active = true)
2. Within `prod`, filter containers: Only `logs` is active
3. Flatten: Create a single list with one container object
4. Build locals map:
   ```hcl
   active_conatiner_map = {
     "0" => {
       storage_account_name = "prodsa"
       container_name = "logs"
       container_access_type = "Private"
       metadata = { env = "prod" }
     }
   }
   ```

### Result

Terraform creates only **1 storage container**:
- Container name: `logs`
- In storage account: `prodsa`
- Access type: `Private`
- With metadata: `{ env = "prod" }`

All other containers and storage accounts are skipped because they have `is_active = false`.

---

## Part 6: Benefits of This Pattern

1. **Selective Deployment**: Only creates what is marked as active.
2. **Multi-Environment**: Different containers/accounts can be active in different environments.
3. **Maintainability**: Add/remove containers by changing the `is_active` flag, no code changes needed.
4. **Clean Tracking**: Terraform tracks only the active resources, avoiding unnecessary state files.
5. **Complex Filtering**: Combines storage-level and container-level filtering in one elegant expression.

---

## Part 7: Expected Input Variable Structure

The variable must match this shape:

```hcl
variable "storage_accounts" {
  type = map(object({
    name     = string
    is_active = bool
    containers = list(object({
      name                  = string
      is_active             = bool
      container_access_type = string
      metadata              = optional(map(string), {})
    }))
  }))
}
```

Example value:
```hcl
storage_accounts = {
  "prod" => {
    name      = "prodstg001"
    is_active = true
    containers = [
      {
        name                  = "logs"
        is_active             = true
        container_access_type = "Private"
        metadata              = { environment = "production" }
      }
      {
        name                  = "old-data"
        is_active             = false
        container_access_type = "Private"
        metadata              = {}
      }
    ]
  }
  "dev" => {
    name      = "devstg001"
    is_active = false
    containers = [...]
  }
}
```

---

## Summary

This code implements **smart conditional creation** of storage containers:
- Only active storage accounts are processed
- Only active containers within those accounts are created
- Metadata and configuration are preserved per container
- The result is a clean, minimal set of Azure resources matching your intended configuration 