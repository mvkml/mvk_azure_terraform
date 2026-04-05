terraform-rg-multi-env/
│
├── main.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
│
├── environments/
│   ├── dev.tfvars
│   ├── qa.tfvars
│   ├── uat.tfvars
│   └── prod.tfvars
│
└── modules/
    └── resource_group/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf