# Terraform Modules in This Project

## What Is a Module?

A module in Terraform is a reusable container of infrastructure code.

- It groups related resources together.
- It accepts input values through variables.
- It returns values through outputs.
- It can be called from different environments to avoid duplicate code.

In simple terms, a module is a function for infrastructure.

## How Modules Are Used Here

This repository uses modules in two ways:

1. Shared module reused by all environments
2. Environment-specific module used only in `dev`

### 1) Shared Resource Group Module

The shared module creates Azure Resource Groups.

- Module location: `modules/resource_group`
- Used by: `dev`, `qa`, `uat`, `prod`

Each environment calls the same module and passes its own naming and tagging values. This gives consistency across environments while keeping code simple.

Inputs passed to the module:

- `rg_name`
- `location`
- `tags`

Outputs returned by the module:

- `resource_group_name`
- `resource_group_id`

### 2) Dev Storage Account Module

In `dev`, there is an additional module for Storage Accounts.

- Module location: `environments/dev/mcp_resources/storageaccount`
- Called from: `environments/dev/main.tf`

This module creates multiple storage accounts using `for_each`.

The root variable is a list, but the storage module expects a map for `for_each`. So you convert list to map using:

```tf
storage_accounts = { for sa in var.storage_accounts : sa.name => sa }
```

This means:

- each storage account object is keyed by `sa.name`
- Terraform can track each account by a stable key
- adding/removing accounts is cleaner and safer

Important:

- Storage account names must be unique in the list, otherwise duplicate map keys will fail.

## Why This Design Is Good

- Reusability: common logic is written once and used many times.
- Consistency: naming/tags are applied in the same way across environments.
- Scalability: new resources can be added as new modules without rewriting everything.
- Maintainability: changes in one module are reflected wherever it is used.

## Quick Summary

- Module = reusable infrastructure building block.
- You use a shared Resource Group module in all environments.
- You use a dev-only Storage Account module for iterative rollout.
- You transform storage account input list to map for `for_each` compatibility.
