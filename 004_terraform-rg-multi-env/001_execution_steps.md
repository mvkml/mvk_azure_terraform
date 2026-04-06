# Terraform Execution Steps

This guide explains the 4 core Terraform commands you asked for:

1. `init`
2. `plan`
3. `apply`
4. `destroy`

## 1) `terraform init`

Initializes the working directory.

- Downloads required providers.
- Configures backend (if defined).
- Prepares Terraform to run in this folder.

Command:

```bash
terraform init
```

## 2) `terraform plan`

Shows what Terraform will create, update, or delete before making changes.

Command (single root with environment var file):

```bash
terraform plan -var-file="environments/dev.tfvars"
```

You can replace `dev.tfvars` with `qa.tfvars`, `uat.tfvars`, or `prod.tfvars`.

## 3) `terraform apply`

Applies the changes from the plan and creates/updates resources in Azure.

Command:

```bash
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

## 4) `terraform destroy`

Deletes resources managed by Terraform for the selected variable file.

Command:

```bash
terraform destroy -var-file="environments/dev.tfvars" -auto-approve
```

## Recommended Order

Run commands in this order:

```bash
terraform init
terraform validate
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars" -auto-approve
```

When cleanup is needed:

```bash
terraform destroy -var-file="environments/dev.tfvars" -auto-approve
```

## Quick Notes

1. Start with `dev` first, then move to higher environments.
2. Double-check plan output before apply.
3. Never run destroy in production unless you are sure.

