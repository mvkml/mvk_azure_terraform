# Detailed Naming Convention Explanation

## Pattern

`<client>-<repository-short-name>-<project-name>-<region-code>-<resource-type>-<environment/deployment>`

Example:

`etna-ubcliams-mcp-ai-cus-rg-dev01`

## Why This Pattern Works

This structure is strong because it encodes ownership, source context, workload, location, Azure resource category, and deployment stage in one deterministic name. It helps with:

- fast filtering in Azure Portal
- easier cost and operations reporting
- predictable Terraform variable-driven name creation
- reduced naming collision risk

## Token-by-Token Explanation

### 1) `<client>`

Purpose:

- Identifies customer, business unit, or tenant boundary.

In example:

- `etna`

Rules:

- lowercase only
- 2-12 characters recommended
- no sensitive legal or regulatory terms

### 2) `<repository-short-name>`

Purpose:

- Connects resource naming to source repository or platform domain.

In example:

- `ubcliams`

Rules:

- keep short but recognizable (3-15 chars)
- avoid generic labels like `infra` unless it is truly shared infra
- use one canonical abbreviation per repo

### 3) `<project-name>`

Purpose:

- Identifies application/workload scope within the repository.

In example:

- `mcp-ai`

Rules:

- 3-20 characters recommended
- may include internal hyphen if needed (`mcp-ai`, `pay-core`)
- must remain stable over time

### 4) `<region-code>`

Purpose:

- Shows deployment geography or paired region intent.

In example:

- `cus` (Central US)

Suggested standard codes:

- `cus` = Central US
- `eus` = East US
- `wus2` = West US 2
- `weu` = West Europe
- `neu` = North Europe
- `ase` = Australia Southeast

Rules:

- use a centrally governed region code list
- never mix aliases for the same region

### 5) `<resource-type>`

Purpose:

- Indicates category of Azure artifact.

In example:

- `rg` (Resource Group)

Common short codes:

- `rg` = resource group
- `vnet` = virtual network
- `subnet` = subnet
- `nsg` = network security group
- `vm` = virtual machine
- `sa` = storage account
- `kv` = key vault
- `asp` = app service plan
- `app` = web app/function app (org preference)

Rules:

- use one approved abbreviation catalog
- do not switch between synonyms (`rg` vs `resgrp`)

### 6) `<environment/deployment>`

Purpose:

- Encodes lifecycle stage plus deployment slot/index.

In example:

- `dev01`

Recommended values:

- `dev01`, `dev02`
- `tst01`
- `uat01`
- `prd01`, `prd02`
- `sbx01`

Rules:

- keep environment codes fixed: `dev`, `tst`, `uat`, `prd`, `sbx`
- use numeric suffix for multiple deployments in same stage
- start at `01` for readability and sorting

## Practical Interpretation of the Example

`etna-ubcliams-mcp-ai-cus-rg-dev01` means:

- owned by client/domain `etna`
- tied to repository/domain `ubcliams`
- project/workload is `mcp-ai`
- deployed in Central US (`cus`)
- this object is a Resource Group (`rg`)
- first development deployment (`dev01`)

## Table: Description of `etna-ubcliams-mcp-ai-cus-rg-dev01`

| Position | Token | Description | Example Meaning |
| --- | --- | --- | --- |
| 1 | `etna` | Client or business boundary identifier | ETNA client/domain |
| 2 | `ubcliams` | Repository short name or platform/domain reference | UBCLIAMS repo/domain |
| 3 | `mcp-ai` | Project or workload name | MCP AI workload |
| 4 | `cus` | Azure region short code | Central US |
| 5 | `rg` | Resource type abbreviation | Resource Group |
| 6 | `dev01` | Environment plus deployment index | Development, instance 01 |

### Full Name Summary

| Full Name | Human-readable Description |
| --- | --- |
| `etna-ubcliams-mcp-ai-cus-rg-dev01` | Resource Group for ETNA, in UBCLIAMS domain, for MCP AI project, deployed in Central US, development instance 01 |

## Azure Compliance Notes for Resource Group Names

Before finalizing this style for Azure Resource Groups, ensure:

- total name length is within Azure RG limit (1-90 chars)
- only allowed characters are used
- name does not end with `.`
- uniqueness is maintained at subscription scope

Reference:

- https://learn.microsoft.com/azure/azure-resource-manager/management/resource-name-rules#microsoftresources

## Governance Recommendations

- maintain a naming dictionary in source control for all token values
- enforce naming with policy checks (CI lint and/or Azure Policy)
- generate names from Terraform locals to avoid manual errors
- avoid adding temporary values (ticket IDs, owner names, dates)

## Terraform Implementation Hint

Build names centrally in one local value and reuse it:

`"${var.client}-${var.repo_short}-${var.project}-${var.region_code}-rg-${var.env}${format("%02d", var.deployment_index)}"`

This keeps naming deterministic and auditable across all modules.

## Profile

VISHNU KIRAN M
End-to-End AI, Cloud, Big Data, IoT & Embedded Solution Designer

I design and deliver end-to-end AI solutions across the full lifecycle, from strategy and architecture to deployment, optimization, and measurable business outcomes. I am an expert in IoT solution design with embedded components, building integrated systems that connect edge devices, cloud platforms, and data/AI pipelines for scalable, production-grade enterprise solutions.

ViKi-Pedia
