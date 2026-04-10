locals {
  common_tags = {
    project   = var.project_name
    managedBy = "terraform"
  }

  resource_groups = {
    for env in var.env_names :
    env => {
      rg_name = "${var.project_name}-${env}-rg"
      tags = merge(local.common_tags, {
        environment = env
      })
    }
  }
}