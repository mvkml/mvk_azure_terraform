locals {
  l_az_openai = [
    for k, v in var.var_az_openai : {
      name           = v.name
      sku_name       = v.sku_name
      location       = var.location
      network_type   = v.network_type
      kind           = v.kind
      custom_subdomain_name = v.custom_subdomain_name
      public_network_access_enabled = v.public_network_access_enabled
      description    = v.description
      is_active      = v.is_active
      models         = { for mk, mv in v.models : mk => mv if mv.is_active }
    } if v.is_active
  ]
}


resource "azurerm_cognitive_account" "rsc_az_openai" {
  for_each = {
    for idx, v in local.l_az_openai : v.name => v
  }

  name                = each.value.name
  location            = var.location  
  resource_group_name = var.resource_group_name
  kind                = each.value.kind
  sku_name            = each.value.sku_name
  custom_subdomain_name = each.value.name
  public_network_access_enabled = each.value.network_type == "Public" ? true : false
  tags               = var.var_az_openai_tags
  #tags               = var.var_az_openai_tags
}


locals {
  l_models = flatten([
    for k, v in var.var_az_openai : [
      for mk, mv in v.models : {
        cognitive_name = v.name
        deployment_key = "${v.name}-${mk}"
        model_name     = mv.model_name
        model_version  = mv.model_version
        sku_name       = mv.sku_name
        capacity       = mv.capacity
        is_active      = mv.is_active
      } if mv.is_active
    ] if v.is_active
  ])
}

resource "azurerm_cognitive_deployment" "rsc_az_openai_deployment" {
  for_each = {
    for v in local.l_models : v.deployment_key => v
  }

  name                 = each.value.deployment_key
  cognitive_account_id = azurerm_cognitive_account.rsc_az_openai[each.value.cognitive_name].id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }
}