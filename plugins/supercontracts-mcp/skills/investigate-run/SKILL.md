---
name: investigate-run
description: Inspect SuperContracts execution evidence and explain a pass, failure, block, or approval requirement.
---

Use `get_run` with the run identifier returned by SuperContracts. Summarize the request, policy outcome, assertion results, and next safe step.

For a failed run, distinguish a contract assertion failure, provider authentication problem, policy denial, approval requirement, and transport error. Do not claim a protected action succeeded until the run evidence says it succeeded.

Do not include tokens, provider secrets, private response bodies, or approval tokens in the summary.
