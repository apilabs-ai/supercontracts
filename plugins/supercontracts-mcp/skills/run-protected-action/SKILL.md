---
name: run-protected-action
description: Validate and execute a protected SuperContracts action with approvals and evidence.
---

Before a side-effecting operation, use `validate_action` or `run_skill` with `mode: validate` when available. State the expected action, environment, and effect before execution.

If a tool returns `approval_required`, preserve the original contract YAML, action, arguments, and trace context. Obtain approval through the configured apilabs-ai approval flow, then resume the original request with its approval token. Do not create a duplicate request, change its arguments, or treat the approval as completed before the original operation succeeds.

After execution, report the policy result, run identifier, and relevant evidence without revealing credentials or approval tokens.
