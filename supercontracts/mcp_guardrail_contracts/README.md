# SuperContracts GitHub MCP Guardrails Demo

A minimal guarded-service contract showing how SuperContracts can **ALLOW/BLOCK GitHub MCP actions** before they run — including a multi-step flow that creates a branch, updates a file, and opens a PR.

---

## What the demo proves

GitHub tools are not called freely. Every action is evaluated against policy first:

> Feature-branch work and PRs are allowed; direct pushes to `main` are blocked.

The contract declares tools, guardrails, and an optional multi-step `flow`. Default is **BLOCK** — anything not explicitly allowed is denied. A coding agent (or you) can validate decisions without executing, then run the flow when ready.

---

## Repository layout

```
mcp_guardrail_contracts/
├── README.md
└── github_mcp_guardrail.yaml   # service, tools, guardrails, flow
```

---

## How the contract is structured

| Section | Role |
| --- | --- |
| `supercontract` / `service` | Contract id + GitHub repo binding + auth |
| `tools` | Declared tools agents may call (maps to upstream GitHub REST/MCP) |
| `guardrails` | ALLOW/BLOCK rules evaluated per action |
| `flow` | Optional multi-step guarded execution |
| `default` | Fallback decision (here: `BLOCK`) |

### Guardrails in this demo

| Rule | When | Decision |
| --- | --- | --- |
| `block_push_to_main` | `push` to `main` | `BLOCK` |
| `allow_create_branch` | `create_branch` | `ALLOW` |
| `allow_modify_feature_branch` | `modify_file` on non-`main` | `ALLOW` |
| `allow_create_pull_request` | `create_pull_request` | `ALLOW` |
| *(default)* | anything else | `BLOCK` |

### Flow (multi-step)

When `flow:` is set, steps run in order. The **first BLOCK stops the flow**:

1. Create feature branch  
2. Update `README.md` on that branch  
3. Open a pull request  

Set `mode: execute` when you want real GitHub side effects. Comment out `flow:` and use top-level `action:` / `args:` for single-action mode. MCP `invoke_guarded` request fields still override when passed.

---

## Secret ARN

`auth_secret` (under `service.connector`) is a reference to a credential in **Auth Vault** on [apilabs.ai](https://apilabs.ai) — not the token itself.

Example:

```yaml
service:
  connector:
    type: rest
    auth_secret: "arn:apilabs:secret:<your-vault-secret-id>"
```

At run time, SuperContracts resolves the ARN and injects the GitHub token. The real secret stays in the vault, so you can share the YAML without leaking credentials.

---

## API authentication

Two ways to authenticate GitHub calls:

### 1. Auth Vault + Secret ARN (recommended)

1. Log in to [apilabs.ai](https://apilabs.ai)
2. Open **Auth Vault** and store a GitHub PAT / token with repo access
3. Copy the generated **Secret ARN**
4. Paste it into `service.connector.auth_secret`

### 2. Add tokens directly

Put the GitHub token straight into the connector / auth fields in the YAML.

Works for quick local runs, but avoid committing real tokens to git.

---

## Setup

1. Point `service.binding.repository` at a repo you can write to (e.g. `owner/repo`)
2. Configure auth (Secret ARN recommended, or token directly — see above)
3. Keep `mode` / `flow` as needed — use `validate_guarded` first if you only want ALLOW/BLOCK checks
4. Set `mode: execute` when ready to run the flow against GitHub

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_guarded_tools` — see tools declared in this contract  
2. `validate_guarded` — check ALLOW/BLOCK **without** executing  
3. `invoke_guarded` — evaluate guardrails, then execute if allowed (or run the multi-step `flow`)  
4. Inspect the decision / results (and run history via `get_run` / `list_test_runs` if applicable)

Typical API-contract flow still works for saved YAML in the explorer:

```
list_contracts → get_contract → … → get_run
```

Pass `connection_id` when saving/running from the explorer so `__run.json`, `__response.json`, and `__ai_context.md` land next to the YAML.
