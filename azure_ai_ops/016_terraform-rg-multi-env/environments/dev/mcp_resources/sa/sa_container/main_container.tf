# Name : sa_main.tf
# Description: This file creates a single Azure Storage Container using example values.
# Author: VISHNU KIRAN M

resource "azurerm_storage_container" "example" {
	name                  = "example-container"
	storage_account_name  = "examplestorageacct"
	container_access_type = "private"
	metadata = {
		environment = "dev"
		owner       = "example-user"
	}
}


 