# Terraform Azure Resource Group Multi-Environment Project

This project demonstrates a reusable Terraform implementation to create Azure Resource Groups for multiple environments (`dev`, `qa`, `uat`, `prod`) using a module-based structure.

## Objective

Provision environment-specific Azure Resource Groups with:
- Reusable Terraform modules
- Standard naming convention
- Common and environment-specific tags
- Environment overlays through `.tfvars` files

## Project Structure

```text
terraform-rg-multi-env/
|-- main.tf
|-- variables.tf
|-- locals.tf
|-- outputs.tf
|-- provider.tf
|-- terraform.tfvars
|-- environments/
|   |-- dev.tfvars
|   |-- qa.tfvars
|   |-- uat.tfvars
|   `-- prod.tfvars
`-- modules/
		`-- resource_group/
				|-- main.tf
				|-- variables.tf
				`-- outputs.tf
```

## Implementation Approach

1. Root module computes environment-specific resource group definitions in `locals.tf`.
2. Root module iterates those definitions using `for_each` in `main.tf`.
3. Each item calls `modules/resource_group` to create one Azure Resource Group.
4. Outputs return a map of environment to resource group name.

### Naming Convention

Resource group name pattern:

`<project_name>-<environment>-rg`

Example:
- `mcpdemo-dev-rg`
- `mcpdemo-qa-rg`
- `mcpdemo-uat-rg`
- `mcpdemo-prod-rg`

## Prerequisites

- Terraform installed
- Azure subscription
- Service principal credentials with permission to create resource groups

## Variables

Root variables are defined in `variables.tf`:
- `client_id`
- `client_secret` (sensitive)
- `tenant_id`
- `subscription_id`
- `project_name`
- `location`
- `env_names`

## How To Run

### 1. Initialize

```bash
terraform init
```

### 2. Validate

```bash
terraform validate
```

### 3. Plan (all environments from `terraform.tfvars`)

```bash
terraform plan -var-file="terraform.tfvars"
```

### 4. Apply

```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

### 5. Destroy

```bash
terraform destroy -var-file="terraform.tfvars" -auto-approve
```

## Run Per Environment

Use a dedicated var file from `environments/`:

```bash
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

Repeat for `qa.tfvars`, `uat.tfvars`, and `prod.tfvars`.

## Expected Output

The root output `resource_group_names` returns a map like:

```hcl
resource_group_names = {
	dev  = "mcpdemo-dev-rg"
	qa   = "mcpdemo-qa-rg"
	uat  = "mcpdemo-uat-rg"
	prod = "mcpdemo-prod-rg"
}
```

## Security Notes

- Do not commit real secrets to source control.
- Keep credential values in local-only `.tfvars` files or environment variables.
- Terraform state files can contain sensitive data and should not be committed.

## Submission Notes

This submission demonstrates:
- Reusable module-based Terraform design
- Multi-environment provisioning with a single codebase
- Standardized naming and tagging strategy
- Clean separation of root orchestration and module implementation
