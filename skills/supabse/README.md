# Skill Register Supabase PII Demo

A minimal Skill Register policy showing how an agent can read customer data through Supabase MCP, with a hard block on PII columns such as credit card and SSN.

---

## What the demo proves

Supabase is exercised as a guarded skill, not a raw MCP tool:

> Read customer rows — allowed for safe columns; blocked when the request targets `credit_card` or `ssn`.

The YAML contains the Supabase MCP endpoint (scoped to a project), `secret_arn` auth, intent mappings, guardrails, and a default deny. Supabase tools live on `https://mcp.supabase.com/mcp`. `run_skill` evaluates the policy first, then calls the mapped MCP tool, so a coding agent (or you) can see exactly what was allowed or blocked.

---

## Repository layout

```
supabse-pii/
├── README.md
└── supabase.yaml   # version, intents, guardrails, default
```

---

## How the skill is structured

| Section | Role |
| --- | --- |
| `mcp_endpoint` | Supabase MCP endpoint (includes `project_ref`) |
| `auth` | Bearer auth resolved from an apilabs `secret_arn` |
| `intents` | Chat/guardrail action -> Supabase MCP tool + operation id |
| `guardrails` | Ordered BLOCK / ALLOW rules |
| `default` | BLOCK anything that does not match a rule |

Intent mapping looks like this:

```yaml
read_customer_data:
  tool: supabase_api_read
  args:
    supabase_api_operation_id: GetCustomers
```

`run_skill` takes the intent name as `action` (`read_customer_data`), not the upstream tool name (`supabase_api_read`).

| Intent | MCP tool | Supabase operation | Policy |
| --- | --- | --- | --- |
| `read_customer_data` | `supabase_api_read` | `GetCustomers` | BLOCK if `column` is `credit_card` or `ssn`; otherwise ALLOW |

Anything else hits `default: BLOCK`.

---

## Authentication

This example authenticates via an apilabs secret ARN rather than an inline token:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: arn:apilabs:secret:<your-secret-id>
```

That matches the current `supabase.yaml`: requests to Supabase MCP use bearer auth resolved from the registered secret.

Do not commit real production secrets into git. Keep credentials in Skill Register / secret management, and only reference them by `secret_arn` in the YAML.

---

## Setup

1. Register this skill in **Skill Register** on [apilabs.ai](https://apilabs.ai) with a name such as `supabase-pii` (or `supabse-pii` to match the folder)
2. Paste `supabase.yaml` as the skill YAML
3. Confirm the file includes:
   - `mcp_endpoint` pointing at your Supabase MCP URL with `project_ref`
   - bearer `auth` with a valid `secret_arn`
   - intent `read_customer_data`
   - guardrails that block PII columns and allow safe reads
4. Enable the skill

Without a valid `mcp_endpoint` and auth, the skill is discoverable but not executable.

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_skills` — find this skill
2. `get_skill` — load the saved YAML and confirm `mcp_endpoint`, `auth`, and intents
3. `list_skill_tools` — confirm intent `read_customer_data`
4. `run_skill` — execute an intent (`mode: validate` checks policy only)

Examples:

- Allowed read: `skill: supabase-pii`, `action: read_customer_data`, `args.column: email`
- Blocked read: `action: read_customer_data`, `args.column: credit_card`
- Blocked read: `action: read_customer_data`, `args.column: ssn`

Pass the **intent name** as `action`. Guardrails run first; Supabase MCP is called only on ALLOW.
