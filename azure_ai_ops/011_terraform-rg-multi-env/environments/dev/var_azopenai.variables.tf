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

    kind             = optional(string, "OpenAI") # This field is optional because the default kind for Azure OpenAI resources is typically "OpenAI". It allows for flexibility in case there are specific requirements to use a different kind, such as "AzureOpenAI", without mandating it for every resource definition.
    
    # The 'custom_subdomain_name' field is optional because not all Azure OpenAI resources may require a custom subdomain name. It provides flexibility for users who may want to specify a custom subdomain for their resource, while allowing others to omit it if they are fine with the default subdomain provided by Azure.
    # same as name but with only lowercase letters and numbers, and hyphens allowed. It is used to create a custom subdomain for the Azure OpenAI resource, which can be beneficial for branding and easier access, but it is not mandatory for all resources.
    custom_subdomain_name = optional(string, null) # This field is optional because not all Azure OpenAI resources may require a custom subdomain name. It provides flexibility for users who may want to specify a custom subdomain for their resource, while allowing others to omit it if they are fine with the default subdomain provided by Azure.
    
    
    public_network_access_enabled = optional(bool, true) # This field is optional because the default setting for public network access is typically enabled (true) for Azure OpenAI resources. It allows users to explicitly disable public network access if they have specific security requirements, while keeping it enabled by default for those who do not specify this field.

    # description is optional because we might have resources that are not defined at the time of defining the variable or we might want to define resources separately. This will be used rarely but it provides flexibility in how we structure our variables and resources.
    description      = optional(string, "For development and testing purposes")
    # The 'is_active' field is required to enable or disable the creation of specific Azure OpenAI resources.
    is_active        = bool
    
  }))
}

# SKU stands for → Stock Keeping Unit