variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "var_az_openai_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}


variable "var_az_openai" {
  type = map(object({
    # The 'name' field is required to uniquely identify each Azure OpenAI resource and is used as the key in the map for easy reference and management.
    name            = string

    # The 'sku' (Stock Keeping Unit) field is required to specify the pricing tier and features of the Azure OpenAI resource, which is essential for provisioning the resource with the desired capabilities and cost structure.
    sku_name     = string

    # regional endpoint is only available in eastus for now, so defaulting to that
    location        = optional(string, "eastus") 

    # The 'network_type' field is optional because the default network type for Azure OpenAI resources is typically "Public". It allows for flexibility in case there are specific requirements to use a different network type, such as "Private", without mandating it for every resource definition.
    # ex: All networks, including the internet, can access this resource.
    network_type     = optional(string, "Public") # This field is optional because the default network type for Azure OpenAI resources is typically "Public". It allows for flexibility in case there are specific requirements to use a different network type, such as "Private", without mandating it for every resource definition.

    kind             = optional(string, "OpenAI") # This field is optional because it defaults to "OpenAI", which is the expected kind for Azure OpenAI resources. This allows for flexibility in case there are specific scenarios where a different kind might be needed, without requiring it to be specified for every resource definition.
    
    custom_subdomain_name = optional(string, null) # This field is optional because not all Azure OpenAI resources may require a custom subdomain name. It provides flexibility for users who may want to use the default subdomain provided by Azure, while still allowing those who need a custom subdomain to specify it when necessary.
   
    public_network_access_enabled = optional(bool, true) # This field is optional because the default value is set to true, which means that public network access is enabled by default for Azure OpenAI resources. This allows users to easily create resources with public access without having to specify this field, while still providing the option to disable public access if needed by setting it to false.

    # description is optional because we might have resources that are not defined at the time of defining the variable or we might want to define resources separately. This will be used rarely but it provides flexibility in how we structure our variables and resources.
    description      = optional(string, "For development and testing purposes")
    # The 'is_active' field is required to enable or disable the creation of specific Azure OpenAI resources.
    is_active        = bool
    
  }))
}

# SKU stands for → Stock Keeping Unit