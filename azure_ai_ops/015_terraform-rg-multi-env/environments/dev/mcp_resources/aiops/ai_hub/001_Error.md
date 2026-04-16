
╷
│ Error: creating Project (Subscription: "ce658dab-cae6-43c7-aa43-3f8c2ea7f68f"
│ Resource Group Name: "etna-ubcliams-mcp-ai-cus-rg-12042251"
│ Account Name: "aifoundrydev122251"
│ Project Name: "mcp_az_open_aidev122251"): performing ProjectsCreate: unexpected status 400 (400 Bad Request) with error: BadRequest: Project can only created under AIServices Kind account with allowProjectManagement set to true.
│ 
│   with module.m_ai_hub.azurerm_cognitive_account_project.project,
│   on mcp_resources\aiops\ai_hub\main_ai_hub.tf line 135, in resource "azurerm_cognitive_account_project" "project":
│  135: resource "azurerm_cognitive_account_project" "project" {
│ 
│ creating Project (Subscription: "ce658dab-cae6-43c7-aa43-3f8c2ea7f68f"
│ Resource Group Name: "etna-ubcliams-mcp-ai-cus-rg-12042251"
│ Account Name: "aifoundrydev122251"
│ Project Name: "mcp_az_open_aidev122251"): performing ProjectsCreate: unexpected status
│ 400 (400 Bad Request) with error: BadRequest: Project can only created under
│ AIServices Kind account with allowProjectManagement set to true.
╵
