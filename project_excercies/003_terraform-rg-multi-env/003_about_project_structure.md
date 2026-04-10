# Terraform Multi-Environment Project (Learning Notes)

## Project Goal

This project shows how to manage Azure infrastructure for multiple environments (`dev`, `qa`, `uat`, `prod`) using reusable Terraform modules.

Instead of writing the same resource code many times, you write it once in a module and call it from each environment.

## Target Structure

```text
terraform-rg-multi-env/
|
|-- modules/
|   `-- resource_group/
|
`-- env/
	|-- dev/
	|   |-- main.tf
	|   |-- provider.tf
	|   |-- variables.tf
	|   |-- terraform.tfvars
	|   `-- backend.tf
	|-- qa/
	|-- uat/
	`-- prod/
```

## How To Understand This Layout

### 1) `modules/resource_group/`

This is the reusable module.

- It contains the real resource definition (`azurerm_resource_group`).
- It accepts inputs like name, location, and tags.
- It can return outputs like resource group name and ID.

Think of it as a reusable template.

### 2) `env/dev`, `env/qa`, `env/uat`, `env/prod`

Each folder is a separate Terraform root for one environment.

- `dev` creates only dev resources.
- `qa` creates only qa resources.
- `uat` creates only uat resources.
- `prod` creates only prod resources.

Think of each folder as an isolated deployment workspace.

## Purpose Of Files Inside Each Environment

### `main.tf`

Calls the module and passes environment-specific values.

### `provider.tf`

Defines Azure provider details and authentication configuration.

### `variables.tf`

Declares input variables used by that environment.

### `terraform.tfvars`

Provides values for variables (for example, naming prefix, location, tags).

### `backend.tf`

Configures remote Terraform state.

Important: each environment should have separate state storage (or separate state key/path) to avoid mixing resources between environments.

## Why This Pattern Is Useful

1. Strong environment isolation.
2. Safer deployments (dev changes do not directly affect prod).
3. Better teamwork and governance.
4. Reusable, maintainable infrastructure code.

## Typical Workflow Per Environment

Run these commands from the specific environment folder (example: `env/dev`).

```bash
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

To remove resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Naming Convention Example

A simple and common pattern:

`<project>-<environment>-rg`

Examples:

- `mcpdemo-dev-rg`
- `mcpdemo-qa-rg`
- `mcpdemo-uat-rg`
- `mcpdemo-prod-rg`

## Security Notes

1. Do not commit real secrets in `terraform.tfvars`.
2. Prefer environment variables, secret stores, or CI/CD secret management.
3. Store Terraform state in a secure remote backend.

## Learning Tip

Start with `dev`, confirm naming and tags, then promote the same module usage pattern to `qa`, `uat`, and finally `prod`.

