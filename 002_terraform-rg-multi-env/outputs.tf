output "resource_group_names" {
  value = {
    for env, mod in module.resource_groups :
    env => mod.resource_group_name
  }
}