# One-Page Evaluation Sheet

## Project Details

- **Project Title:** Terraform Azure Resource Group Multi-Environment
- **Repository/Folder:** `002_terraform-rg-multi-env`
- **Date:** 2026-04-05
- **Tooling:** Terraform, AzureRM Provider

## 1. Architecture Summary

### Overview

This solution uses a **module-based Terraform architecture** to provision Azure Resource Groups for multiple environments from a single codebase.

### Logical Flow

1. Input variables are loaded from `terraform.tfvars` (or `environments/*.tfvars`).
2. `locals.tf` builds a computed map of environment-specific resource group definitions.
3. `main.tf` loops with `for_each` across that map and calls `modules/resource_group` once per environment.
4. Module creates one `azurerm_resource_group` per environment.
5. `outputs.tf` returns a map of environment to created resource group name.

### Core Components

- **Root Module**
  - `provider.tf`: Provider setup and authentication inputs.
  - `variables.tf`: Root-level inputs and types.
  - `locals.tf`: Naming/tagging and per-environment object construction.
  - `main.tf`: Module orchestration (`for_each`).
  - `outputs.tf`: Consolidated output map.
- **Reusable Child Module** (`modules/resource_group`)
  - `main.tf`: Resource group creation.
  - `variables.tf`: Strict module interface.
  - `outputs.tf`: Resource group outputs (name/id).
- **Environment Overlays**
  - `environments/dev.tfvars`, `qa.tfvars`, `uat.tfvars`, `prod.tfvars`

## 2. Design Choices (and Why)

1. **Reusable module for resource groups**
	- Reduces duplication and supports future extension.

2. **`for_each` over environment map (from locals)**
	- Clean and scalable pattern for multi-environment provisioning.

3. **Naming standard: `<project_name>-<env>-rg`**
	- Makes resources easy to identify by environment.

4. **Tag strategy with shared + environment tags**
	- Adds consistency and supports governance/cost tracking.

5. **Provider version pinned (`azurerm = 4.1.0`)**
	- Improves deterministic behavior across machines.

6. **Security hardening for submission**
	- Replaced tracked credential values with placeholders.
	- Added `.gitignore` for state and sensitive Terraform artifacts.

## 3. Validation and Execution Status

- `terraform validate`: **PASS**
- Configuration syntax and structure: **Valid**

## 4. Expected Output (Functional Result)

When `env_names = ["dev", "qa", "uat", "prod"]`, expected output map:

```hcl
resource_group_names = {
  dev  = "<project>-dev-rg"
  qa   = "<project>-qa-rg"
  uat  = "<project>-uat-rg"
  prod = "<project>-prod-rg"
}
```

## 5. Screenshots Checklist (Submission Evidence)

Use this checklist while preparing your final report/PDF.

### A. Project Structure Evidence

- [ ] Screenshot of workspace tree showing root files, `environments/`, and `modules/resource_group/`

### B. Code Design Evidence

- [ ] `locals.tf` showing computed `resource_groups` map
- [ ] `main.tf` showing module call with `for_each`
- [ ] `modules/resource_group/main.tf` showing `azurerm_resource_group`
- [ ] `outputs.tf` showing `resource_group_names` output

### C. Execution Evidence

- [ ] Terminal: `terraform init` successful
- [ ] Terminal: `terraform validate` successful
- [ ] Terminal: `terraform plan -var-file="terraform.tfvars"` summary
- [ ] Terminal: `terraform apply -var-file="terraform.tfvars" -auto-approve` success (if executed)

### D. Azure Portal Evidence

- [ ] Azure Resource Groups list showing created RG names for each environment
- [ ] One RG detail page showing tags (`project`, `managedBy`, `environment`)

### E. Security/Hygiene Evidence

- [ ] `terraform.tfvars` screenshot showing placeholder secrets (not real credentials)
- [ ] `.gitignore` screenshot showing Terraform state ignore rules

## 6. Evaluation Rubric Snapshot (Quick Grading Aid)

| Criterion | Status | Notes |
|---|---|---|
| Multi-environment architecture | Met | Implemented via `for_each` + env list |
| Reusability/modularity | Met | Dedicated `resource_group` module |
| Naming and tagging standards | Met | Centralized in `locals.tf` |
| Terraform validation quality | Met | `terraform validate` passed |
| Security handling in submission | Met | Secrets sanitized, ignore rules added |

## 7. Final Assessment Statement

This submission satisfies the expected implementation pattern for a Terraform multi-environment Azure Resource Group project. It is modular, scalable, and submission-ready, with improved documentation and safer secret/state handling practices.
