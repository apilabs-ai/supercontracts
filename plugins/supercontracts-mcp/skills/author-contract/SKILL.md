---
name: author-contract
description: Create or update a SuperContract while preserving Auth Vault and guardrail boundaries.
---

Use `list_contracts` before changing an existing contract. Load the selected contract with `get_contract`, then use `save_contract` only after the user has reviewed the intended YAML.

Never put provider access tokens, API keys, browser cookies, approval tokens, or reusable secret ARNs in generated YAML. Reference provider credentials through apilabs-ai Auth Vault. For a new action, prefer a narrow default-deny policy and a read-only or validate-only first run.

When saving a contract, clearly identify the target folder and whether the operation creates or updates a file.
