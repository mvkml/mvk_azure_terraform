module "resource_groups" {
  for_each = local.resource_groups

  source = "./modules/resource_group"

  rg_name   = each.value.rg_name
  location  = var.location
  tags      = each.value.tags
}