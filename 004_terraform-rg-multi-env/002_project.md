terraform-rg-multi-env/
│
├── modules/
│   └── resource_group/
│
└── env/
    ├── dev/
    │   ├── main.tf
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── terraform.tfvars
    │   └── backend.tf
    ├── qa/
    ├── uat/
    └── prod/