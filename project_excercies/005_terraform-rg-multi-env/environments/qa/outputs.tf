output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  sensitive   = true
  description = "The name of the resource group"
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
  description = "The ID of the resource group"
}