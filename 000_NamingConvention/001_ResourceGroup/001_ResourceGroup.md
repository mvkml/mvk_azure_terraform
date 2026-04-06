# Azure Resource Group Naming Convention

## 1. Official Azure Rules (Must Follow)

Resource group names in Azure must follow these constraints:

- Scope uniqueness: unique within a subscription.
- Length: 1-90 characters.
- Allowed characters:
	- letters and digits (Unicode letters and numbers are supported)
	- underscore (`_`)
	- hyphen (`-`)
	- period (`.`)
	- parentheses (`(` and `)`)
- Restriction: cannot end with a period (`.`).
- Case: names are case-insensitive in Azure operations.

Reference:
- https://learn.microsoft.com/azure/azure-resource-manager/management/resource-name-rules#microsoftresources

## 2. Recommended Convention (Team Standard)

Use a stable, readable, and searchable pattern:

`rg-<workload>-<env>-<region>-<instance>`

Where:

- `rg`: fixed prefix for resource group.
- `<workload>`: short application or business workload name.
- `<env>`: environment code.
- `<region>`: Azure region short code.
- `<instance>`: 2-3 digit sequence for uniqueness.

## 3. Component Standards

### 3.1 Workload

- Lowercase only.
- Keep short and meaningful (3-15 chars).
- Use hyphen-separated words if needed.
- Avoid sensitive business terms.

Examples: `payments`, `corebank`, `hr-portal`

### 3.2 Environment

Use one of:

- `dev`
- `tst`
- `uat`
- `prd`
- `sbx`

### 3.3 Region

Suggested short codes:

- `weu` = West Europe
- `neu` = North Europe
- `eus` = East US
- `wus2` = West US 2
- `ase` = Australia Southeast

### 3.4 Instance

- Numeric sequence, usually `001`, `002`, ...
- Use `001` for the first RG in a naming lane.

## 4. Examples

- `rg-payments-dev-weu-001`
- `rg-payments-prd-weu-001`
- `rg-datahub-uat-neu-002`
- `rg-shared-prd-eus-001`

## 5. Do and Don't

Do:

- Keep names stable (do not include owner names or ticket numbers).
- Keep names deterministic and automation-friendly.
- Keep workload and env explicit for quick filtering.

Don't:

- Do not use spaces.
- Do not end with a period.
- Do not embed sensitive or regulatory identifiers.
- Do not use random strings unless required by policy.

## 6. Terraform-Friendly Guidance

For Terraform modules, pass naming components and build names in one place.

Example construction logic:

`rg-${var.workload}-${var.environment}-${var.region_code}-${format("%03d", var.instance_number)}`

Suggested validation intent:

- lowercase, digits, and hyphen for convention consistency
- still remain within Azure max length (90)

---

If your organization already has landing zone abbreviations, align `workload`, `env`, and `region` values to that central standard.
