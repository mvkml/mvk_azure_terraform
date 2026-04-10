# Azure Terraform Multi-Environment Implementation

## Profile

### VISHNU KIRAN M
End-to-End AI, Cloud, Big Data, IoT & Embedded Solution Designer

I design and deliver end-to-end AI solutions across the full lifecycle, from strategy and architecture to deployment, optimization, and measurable business outcomes. I am an expert in IoT solution design with embedded components, building integrated systems that connect edge devices, cloud platforms, and data/AI pipelines for scalable, production-grade enterprise solutions.

ViKi-Pedia

## 1) What This Project Does

This repository provisions Azure infrastructure using Terraform with environment separation.

- Environments: `dev`, `qa`, `uat`, `prod`
- Shared reusable module: Resource Group module
- Environment-specific extension: Storage Account module in `dev`
- Naming strategy: deterministic, convention-based resource naming

This design demonstrates how to scale infrastructure safely across environments while keeping common logic reusable.

## 2) High-Level Architecture

- Each environment folder is an independent Terraform root module.
- All environments consume `modules/resource_group` to create a Resource Group.
- `dev` additionally calls a nested storage module (`environments/dev/mcp_resources/storageaccount`) to create one or more storage accounts.

Flow:

1. Load provider + variables for the selected environment.
2. Build naming/tag locals.
3. Create resource group through shared module.
4. (Dev only) Transform storage account list to map, then create storage accounts with `for_each`.
5. Expose outputs.

## 3) Repository Structure

- `modules/resource_group/`
- `environments/dev/`
- `environments/qa/`
- `environments/uat/`
- `environments/prod/`

Important `dev` files:

- `main.tf`: wires Resource Group module and Storage Account module
- `provider.tf`: AzureRM provider (`hashicorp/azurerm`, pinned to `4.1.0`)
- `variables.tf`: root variables (credentials, naming, tagging, env)
- `sa.variables.tf`: storage account variable schema (list input)
- `sa.auto.tfvars`: storage account values auto-loaded by Terraform
- `terraform.tfvars`: environment values (credentials + naming parameters)

## 4) Core Implementation Details

### 4.1 Shared Resource Group Module

`modules/resource_group` is reusable and environment-agnostic.

Inputs:

- `rg_name`
- `location`
- `tags`

Outputs:

- `resource_group_name`
- `resource_group_id`

### 4.2 Environment Naming Convention

Resource Group name is assembled in each environment using locals:

`<client_name>-<repository_short_name>-<project_name>-<location_id>-<resource_type>-<environment_code>`

Example:

`etna-ubcliams-mcp-ai-cus-rg-dev01`

This supports predictable naming across subscriptions and deployment stages.

### 4.3 Tagging Strategy

Common tags are generated once in locals and applied consistently:

- `project`
- `environment`
- `managedBy`

### 4.4 Dev Storage Account Design

The storage module expects a map for `for_each`, but the root variable is a list.

Transformation used in `environments/dev/main.tf`:

`storage_accounts = { for sa in var.storage_accounts : sa.name => sa }`

Why this is good:

- Stable keys for `for_each`
- Clear identity per storage account
- Supports creating N storage accounts from one input list

Important rule:

- `name` must be unique per entry, otherwise Terraform will fail with duplicate map key errors.

## 5) Environment Behavior Matrix

- `dev`: Resource Group + Storage Accounts
- `qa`: Resource Group
- `uat`: Resource Group
- `prod`: Resource Group

This allows feature rollout in `dev` first before promoting additional resources to higher environments.

## 6) How To Run

From any environment folder (example: `environments/dev`):

```powershell
terraform init
terraform validate
terraform plan
```

For `dev`, because `sa.auto.tfvars` is used, `terraform plan` can run without explicit `-var-file` for storage inputs.

## 7) Showcase Talking Points For Clients

Use these points in your Git repository demo:

- Multi-environment design with isolated roots (`dev/qa/uat/prod`)
- Reusability through shared Terraform modules
- Standardized naming and tagging for governance
- Progressive delivery pattern (`dev` has additional module integration)
- Data-driven resource creation using `for_each` + object schema
- Provider version pinning for reproducibility

## 8) Production Readiness Notes

Before public sharing or client handoff:

1. Do not commit real credentials in `.tfvars` files.
2. Keep only sample placeholders in `terraform.tfvars.example`.
3. Ensure Terraform state files are excluded from Git (already handled in `.gitignore`).
4. Consider remote backend (Azure Storage) for team-safe state management and locking.

## 9) Suggested Next Enhancement

- Promote storage account module usage to `qa/uat/prod` when validated in `dev`.
- Extract storage module from `environments/dev/mcp_resources/storageaccount` into top-level `modules/` for full cross-environment reuse.
- Add CI checks (`terraform fmt -check`, `terraform validate`, `terraform plan`) for PR quality gates.
