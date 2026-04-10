# Resource Group Naming Convention

## Example Resource Group Name

`aetna-ubcliams-mcp-ai-cus-rg-p27`

This resource group name is built using multiple business and technical parts joined with a hyphen (`-`).

## Why We Use A Naming Convention

A naming convention helps clients, developers, and operations teams understand a resource without opening Azure and checking its details manually.

With one name, we can quickly identify:

1. Which client the resource belongs to
2. Which application or repository created it
3. Which project it supports
4. Which Azure region it belongs to
5. What kind of Azure resource it is
6. Which deployment iteration it represents

## Full Breakdown

Resource group name:

`aetna-ubcliams-mcp-ai-cus-rg-p27`

Split into parts:

| Part | Meaning | Description |
|------|---------|-------------|
| `aetna` | Client name | Identifies the customer or business owner of the resource |
| `ubcliams` | Repository short name | Short technical identifier linked to the source repository or solution |
| `mcp-ai` | Project name | Business or application project name |
| `cus` | Region short code | Short code for the Azure region |
| `rg` | Resource type | Indicates that this is a Resource Group |
| `p27` | Deployment marker | Indicates production and deployment/version count 27 |

## Detailed Meaning Of Each Part

### 1) `aetna`

This is the **client name**.

- It tells us who owns the resource.
- It is useful when one Azure subscription contains resources for multiple clients or business units.
- Anyone looking at the name can immediately identify that the resource belongs to Aetna.

### 2) `ubcliams`

This is the **repository short name**.

- It connects the Azure resource to the codebase or delivery unit.
- It helps technical teams trace the resource back to the repository, pipeline, or application source.
- Short names are preferred because full repository names can become too long.

Important note:

You provided `Repository Short Name: ubcliamrp`, but the final example uses `ubcliams`.

That means one of these is likely a typo. The naming document should use only one standard value to avoid confusion.

### 3) `mcp-ai`

This is the **project name**.

- It tells the client and delivery team which business initiative or application this resource supports.
- In this example, the resource group belongs to the `mcp-ai` project.
- This becomes especially useful when the same client has multiple projects running in Azure.

### 4) `cus`

This is the **region short code**.

- It represents the Azure location where the resources will be deployed.
- You mentioned `Central India`, and `cus` is being used as the short regional code in this naming model.
- Region short codes keep names compact and consistent.

Client explanation:

Instead of writing the full location name every time, a short code is used so the resource name stays readable and within Azure naming limits.

### 5) `rg`

This is the **resource type identifier**.

- `rg` means **Resource Group**.
- This helps distinguish it from names such as:
	- `vm` for virtual machine
	- `vnet` for virtual network
	- `st` for storage
- A person can identify the resource category just by reading the suffix.

### 6) `p27`

This is the **environment and deployment marker**.

In your explanation:

- `p` stands for **Production**
- `27` means this is the **27th deployment** or release iteration

This is useful for:

1. Tracking deployment cycles
2. Differentiating between versions or rollout stages
3. Supporting audit and operational clarity

## Simple Business Interpretation

The name `aetna-ubcliams-mcp-ai-cus-rg-p27` can be explained to a client like this:

> This is the Azure Resource Group for the Aetna client, created from the `ubcliams` solution repository, for the `mcp-ai` project, deployed in the Central India region, and marked as a production deployment iteration `27`.

## Recommended Standard Format

You can describe the standard as:

`<client>-<repository-short-name>-<project-name>-<region-code>-<resource-type>-<environment/deployment>`

Example:

`aetna-ubcliams-mcp-ai-cus-rg-p27`

## Benefits Of This Naming Standard

1. Easy to identify ownership
2. Easy to identify project and repository mapping
3. Easy to filter Azure resources by name
4. Better governance and audit readability
5. Easier support and operations handover

## Final Recommendation

Before using this naming convention in Terraform or Azure, confirm these two items:

1. Whether the repository short name should be `ubcliamrp` or `ubcliams`
2. Whether `cus` is the approved short code for `Central India` in your organization

Once these are confirmed, keep the same pattern in all environments for consistency.

## Powered By

**Vishnu Kiran M**

**End-to-End AI, Cloud & Big Data Solution Designer**

I design and deliver end-to-end AI solutions across the full lifecycle, covering solution architecture, cloud engineering, data platforms, automation, deployment, and production readiness.

VIKI-Pedia