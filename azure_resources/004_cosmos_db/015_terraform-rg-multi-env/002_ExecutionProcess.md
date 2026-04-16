# Terraform Execution Lifecycle

This document describes the complete execution lifecycle for this project from setup to deployment, validation, operations, and teardown.

## 1) Lifecycle Overview

1. Prepare environment and credentials
2. Select target environment folder (`dev`, `qa`, `uat`, `prod`)
3. Initialize Terraform working directory
4. Validate configuration
5. Generate and review execution plan
6. Apply infrastructure changes
7. Verify deployed resources and outputs
8. Operate safely (state, drift, updates)
9. Destroy resources when needed

## 2) Prerequisites

1. Terraform installed
2. Azure subscription and service principal credentials
3. Required permissions for resource creation in target subscription
4. Project cloned locally

Recommended check:

```powershell
terraform version
```

## 3) Choose Target Environment

Run commands from the required environment root:

- `environments/dev`
- `environments/qa`
- `environments/uat`
- `environments/prod`

Example:

```powershell
cd environments/dev
```

## 4) Variable Loading Behavior

Terraform automatically loads:

1. `terraform.tfvars`
2. `*.auto.tfvars`

In this project:

1. `dev` uses `terraform.tfvars` and `sa.auto.tfvars` automatically
2. `qa`, `uat`, `prod` use their own `terraform.tfvars` (or `terraform.tfvars.example` as template)

If any file is not named as above, pass it explicitly using `-var-file`.

## 5) Step-by-Step Execution

### Step 1: Initialize

Purpose: download providers/modules and prepare local working directory.

```powershell
terraform init
```

### Step 2: Validate

Purpose: static validation of syntax and references.

```powershell
terraform validate
```

### Step 3: Plan

Purpose: preview exact changes before deployment.

```powershell
terraform plan
```

Optional saved plan:

```powershell
terraform plan -out tfplan
```

### Step 4: Apply

Purpose: create/update infrastructure in Azure.

```powershell
terraform apply
```

If using saved plan:

```powershell
terraform apply tfplan
```

Non-interactive (for automation):

```powershell
terraform apply -auto-approve
```

## 6) Post-Deployment Verification

1. Check Terraform outputs
2. Confirm resources in Azure Portal
3. Re-run plan to confirm no pending drift

Commands:

```powershell
terraform output
terraform plan
```

Expected stable state: `No changes. Your infrastructure matches the configuration.`

## 7) Update Lifecycle (Change Management)

When making changes:

1. Edit Terraform code/variables
2. Run `terraform validate`
3. Run `terraform plan`
4. Review impact
5. Run `terraform apply`
6. Verify resources and outputs

This is the repeatable day-2 operations loop.

## 8) Drift Detection Lifecycle

Drift means actual cloud resources differ from Terraform state/config.

Drift check:

```powershell
terraform plan
```

If drift appears:

1. Review whether change was intentional
2. Either update Terraform code to match reality
3. Or apply Terraform to enforce desired state

## 9) Destroy Lifecycle (Teardown)

Use when environment cleanup is needed.

```powershell
terraform destroy
```

Automation mode:

```powershell
terraform destroy -auto-approve
```

Best practice: never run destroy on production without explicit approval and impact review.

## 10) Environment-Specific Notes For This Project

1. All environments call shared module `modules/resource_group`
2. `dev` also deploys storage accounts through `mcp_resources/storageaccount`
3. Storage accounts in `dev` are created from list input transformed to map:

```tf
storage_accounts = { for sa in var.storage_accounts : sa.name => sa }
```

4. Storage account names must be unique

## 11) CI/CD Lifecycle (Recommended)

Suggested pipeline order:

1. `terraform fmt -check`
2. `terraform init`
3. `terraform validate`
4. `terraform plan`
5. Approval gate
6. `terraform apply -auto-approve`

For production, enforce manual approval before apply.

## 12) Security and Governance Checklist

1. Do not commit secrets in `.tfvars`
2. Keep sample files as `terraform.tfvars.example`
3. Keep state files out of Git (already configured)
4. Prefer remote backend with locking for team usage
5. Use least-privilege service principal permissions

## 13) Quick Command Reference

```powershell
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
terraform destroy
```

This is the complete execution lifecycle for this Terraform project.
 