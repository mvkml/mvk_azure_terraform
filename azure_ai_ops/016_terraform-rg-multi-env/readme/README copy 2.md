# Terraform Error Fix: Invalid 'for' expression

## Why this error happens

Your expression uses invalid `for` syntax in Terraform.

In Terraform, the correct order is:

- List comprehension: `[for x in xs : VALUE if CONDITION]`
- Map comprehension: `{for x in xs : KEY => VALUE if CONDITION}`

You currently have `if ... =>` inside the loop header, which causes:

`Extra characters after the end of the 'for' expression.`

---

## Corrected code (map output)

Use this if you need a map keyed by storage account + container name:

```hcl
locals {
	active_container_map = {
		for item in flatten([
			for sa in var.storage_accounts : [
				for container in sa.containers : {
					storage_account_name  = sa.name
					container_name        = container.name
					container_access_type = container.container_access_type
					metadata              = container.metadata
				} if container.is_active
			] if sa.is_active
		]) :
		"${item.storage_account_name}.${item.container_name}" => item
	}
}
```

---

## Alternative (list output)

If you only need a list and not a map:

```hcl
locals {
	active_container_list = flatten([
		for sa in var.storage_accounts : [
			for container in sa.containers : {
				storage_account_name  = sa.name
				container_name        = container.name
				container_access_type = container.container_access_type
				metadata              = container.metadata
			} if container.is_active
		] if sa.is_active
	])
}
```

---

## Notes

- Fixed typo: `active_conatiner_map` -> `active_container_map`.
- You can use `if sa.is_active` instead of `if sa.is_active == true`.
- After updating, run:

```bash
terraform validate
terraform plan
```
*** End Patch
 