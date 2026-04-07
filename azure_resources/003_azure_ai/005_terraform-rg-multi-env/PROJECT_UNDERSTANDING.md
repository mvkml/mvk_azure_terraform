# Project Understanding Document

## 1. Project Purpose

This repository is a multi-environment Terraform setup for Azure infrastructure provisioning.

Current code behavior:
- Deploys an Azure Resource Group in all environments (`dev`, `qa`, `uat`, `prod`)
- Deploys Azure AI Search services in `dev` only (filtered by `is_active`)
- Uses a reusable shared module for Resource Group creation
- Uses deterministic naming/tagging conventions across environments

## 2. Repository Structure and Meaning

### Root-level docs
- `README.md`: high-level summary and operating guidance
- `001_AzureAISearch.md` and `001_AzureAISearch copy.md`: conceptual AI Search notes (duplicate content)
- `001_StorageAccount.md`: conceptual module explanation (partly outdated vs current code)
- `002_ExecutionProcess.md`: Terraform lifecycle and operations guide

### Terraform code layout
- `modules/resource_group/`: reusable module for Azure Resource Group
- `environments/dev/`: root module for dev (RG + AI Search)
- `environments/qa/`: root module for qa (RG only)
- `environments/uat/`: root module for uat (RG only)
- `environments/prod/`: root module for prod (RG only)

### Dev-specific nested modules
- `environments/dev/mcp_resources/ai_search/`: active module used by `dev/main.tf`
- `environments/dev/mcp_resources/storageaccount/`: module exists but currently not wired in `dev/main.tf`

## 3. Actual Terraform Architecture

### 3.1 Shared module: Resource Group

`modules/resource_group/main.tf`
- Creates `azurerm_resource_group.rg`

Inputs:
- `rg_name` (string)
- `location` (string)
- `tags` (map(string))

Outputs:
- `resource_group_name`
- `resource_group_id`

### 3.2 Environment root modules

All environments have the same pattern:
- `provider.tf`: AzureRM provider pinned at `=4.1.0`
- `variables.tf`: credentials + naming/tagging variables
- `main.tf`: computes `locals` and invokes `modules/resource_group`
- `outputs.tf`: exports RG outputs

### 3.3 Dev extension: Azure AI Search

`environments/dev/main.tf` adds:
- `module "ai_search"` with source `./mcp_resources/ai_search`
- Dependency on RG module via `depends_on = [module.resource_group]`
- Filtered map input:
  - `ai_search_services = { for k, v in var.ai_search_services : k => v if v.is_active }`

`environments/dev/mcp_resources/ai_search/aimain.tf`
- Creates `azurerm_search_service` using `for_each = var.ai_search_services`

AI Search module input object schema:
- `name` (string)
- `sku` (string)
- `replica_count` (number)
- `partition_count` (number)
- `is_active` (bool)

Output:
- `ai_search_service_names` map

## 4. Naming, Tagging, and Convention Model

### 4.1 Naming formula

In each environment `main.tf`, RG name is built as:

`<client_name>-<repository_short_name>-<project_name>-<location_id>-<resource_type>-<environment_code>`

Example pattern in repo comments:
- `etna-ubcliams-mcp-ai-cus-rg-dev01`

### 4.2 Tagging model

Common tags are set in `locals.common_tags`:
- `project = var.project_name`
- `environment = var.environment`
- `managedBy = var.managedby`

These tags are passed to RG module and AI Search module.

## 5. Environment Behavior Matrix

- `dev`
  - Resource Group: yes
  - Azure AI Search: yes (only entries with `is_active = true`)
  - Storage Account module: present in repo but not currently invoked

- `qa`
  - Resource Group: yes
  - Azure AI Search: no
  - Storage Account: no

- `uat`
  - Resource Group: yes
  - Azure AI Search: no
  - Storage Account: no

- `prod`
  - Resource Group: yes
  - Azure AI Search: no
  - Storage Account: no

## 6. Variable and Data-Flow Understanding

### 6.1 Credentials

Each environment expects:
- `client_id`
- `client_secret`
- `tenant_id`
- `subscription_id`

Provider auth is explicit in `provider.tf`.

### 6.2 Configuration model

Per environment variables include:
- `project_name`, `location`, `env_names`
- naming components (`location_id`, `environment`, `client_name`, `repository_short_name`, `resource_type`, `environment_code`)
- governance tag source (`managedby`)

### 6.3 Auto-loaded tfvars in dev

`dev` contains:
- `terraform.tfvars`
- `aisearch.auto.tfvars`
- `sa.auto.tfvars`

Terraform automatically loads `terraform.tfvars` and `*.auto.tfvars`.

## 7. Drift Between Docs and Code

The repository docs and active code are not fully aligned:

1. `README.md` and `001_StorageAccount.md` describe dev storage deployment as active.
2. Current `environments/dev/main.tf` does not call the storage module.
3. `environments/dev/work_backup.txt` contains a previous storage module block, indicating prior wiring.

Interpretation:
- Storage account deployment appears to be a previous stage or temporarily disabled.
- AI Search became the active dev extension module.

## 8. Security and Operational Findings

## Critical

1. Real secrets are committed in source control:
- `environments/dev/terraform.tfvars` contains real-looking `client_id`, `client_secret`, `tenant_id`, and `subscription_id` values.

Immediate remediation:
- Rotate the exposed service principal secret
- Move secrets out of committed tfvars (env vars, secure pipeline variables, secret store)
- Keep only placeholder example files for committed config

## Medium

2. Local state file present in `dev` folder (`terraform.tfstate` and backup)
- acceptable for local testing, not ideal for collaboration
- use remote backend with state locking for team-safe workflows

## Low

3. Duplicate conceptual document:
- `001_AzureAISearch.md` and `001_AzureAISearch copy.md` are duplicates.

4. Unused/empty artifacts:
- `environments/dev/mcp_resources/ai_search/terraform.tfvars` empty
- `environments/dev/mcp_resources/storageaccount/saterraform.tfvars` empty

## 9. How Execution Works (As-Is)

From target environment folder:
1. `terraform init`
2. `terraform validate`
3. `terraform plan`
4. `terraform apply`

As currently wired:
- `dev`: creates RG + active AI Search services
- `qa/uat/prod`: create RG only

## 10. Suggested Cleanup/Hardening Roadmap

1. Security first
- Remove secrets from `environments/dev/terraform.tfvars`
- Rotate credentials
- Add safe onboarding with `terraform.tfvars.example` in `dev`

2. Documentation alignment
- Update `README.md` and `001_StorageAccount.md` to reflect current architecture (AI Search active, storage inactive)
- Optionally keep a historical section for storage implementation

3. Standardize environment capability
- Decide whether AI Search should remain dev-only or be promoted gradually to qa/uat/prod

4. State management
- Introduce remote backend (Azure Storage + locking) for non-local usage

5. Module hygiene
- Remove or archive inactive storage module wiring if not needed
- If needed, re-enable explicitly in `dev/main.tf` and add tests/checks

## 11. Quick Mental Model

Think of this repo as:
- A stable multi-environment RG baseline via shared module
- A feature branch pattern in `dev` where additional resources are tested (currently AI Search)
- A naming/tagging governance framework applied uniformly
- Documentation that needs one round of reconciliation with current Terraform code
