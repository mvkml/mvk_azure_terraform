# Azure AI Search in This Terraform Project

## Purpose of This Document

This file explains how Azure AI Search is implemented in this repository, with focus on the current Terraform code and deployment behavior.

Reference: see PROJECT_UNDERSTANDING.md for complete project-wide context.

## Current Implementation Status

Azure AI Search is currently deployed only in the dev environment.

- Dev: Resource Group + Azure AI Search
- QA: Resource Group only
- UAT: Resource Group only
- PROD: Resource Group only

## Code Location

- Environment root wiring: environments/dev/main.tf
- Dev AI Search input schema: environments/dev/aisearch.variables.tf
- Dev AI Search values: environments/dev/aisearch.auto.tfvars
- AI Search module code: environments/dev/mcp_resources/ai_search/aimain.tf
- AI Search module inputs: environments/dev/mcp_resources/ai_search/variables.tf
- AI Search module outputs: environments/dev/mcp_resources/ai_search/aioutputs.tf

## How AI Search Is Wired

The dev root module calls the AI Search module after creating the resource group.

1. Resource group is created through shared module modules/resource_group.
2. AI Search module receives resource_group_name and location from dev root.
3. AI Search services are filtered using is_active.
4. Active entries are created with for_each.

The key filter used in dev main.tf:

ai_search_services = { for k, v in var.ai_search_services : k => v if v.is_active }

This allows toggling services on or off from variable files without changing module code.

## AI Search Variable Contract

Each service entry in ai_search_services must include:

- name
- sku
- replica_count
- partition_count
- is_active

Type model is map(object(...)), which gives strong validation during plan/apply.

## Example from Current Dev Inputs

Defined in environments/dev/aisearch.auto.tfvars:

- search1: active true
- search2: active false

Result:

- search1 is created
- search2 is skipped

## Resource Created

The AI Search module creates:

- azurerm_search_service.ai_search_services (for_each)

The module output returns a map of created service names:

- ai_search_service_names

## Naming and Governance Alignment

AI Search is deployed into the same environment resource group created via the naming convention used across this project:

<client>-<repository-short-name>-<project-name>-<location-id>-<resource-type>-<environment-code>

Common tags are passed from dev locals to keep governance consistent:

- project
- environment
- managedBy

## Execution Steps (Dev)

Run from environments/dev:

1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply

Because aisearch.auto.tfvars is auto-loaded, no extra var-file flag is required for AI Search service definitions.

## Important Notes

1. This repository currently tests extended resources in dev first.
2. AI Search can be promoted to qa/uat/prod by adding equivalent module wiring and variable files.
3. Secret handling must be improved before broader rollout (do not store real credentials in committed tfvars).

## Quick Summary

In this codebase, Azure AI Search is an active dev-only extension on top of the shared multi-environment resource group baseline. Service creation is data-driven and controlled by is_active flags in variable inputs.
