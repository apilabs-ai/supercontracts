# Skill Register

Skill Register turns third-party MCP (or REST) APIs into **guarded skills** that agents can discover and run from chat — without giving them raw, unbounded tool access.

You register a named skill on [apilabs.ai](https://apilabs.ai) with YAML that defines:

- Which MCP/REST endpoint to call
- How to authenticate
- Which **intents** (chat actions) map to upstream tools
- Ordered **guardrails** (ALLOW / BLOCK)
- A **default deny** for anything that does not match

`run_skill` evaluates the policy first, then calls the mapped tool only on ALLOW. Agents (or you) see exactly what was allowed or blocked.

---

## What this folder is

Ready-to-paste Skill Register demos. Each subdirectory is one skill: a YAML policy plus a tool-specific README.

| Demo | Domain idea | What the policy proves |
| --- | --- | --- |
| [github-skill](./github-skill/) | GitHub Copilot MCP | Push / edit on feature branches and open PRs — allowed; force push or writes to `main` / `master` — blocked |
| [stripe-refund](./stripe-refund/) | Stripe MCP | List payments; refund up to $500 — allowed; above $500 — blocked |
| [supabse-pii](./supabse-pii/) | Supabase MCP | Read customer rows — allowed for safe columns; `credit_card` / `ssn` — blocked |

Use these as templates when registering skills in Skill Register, then connect SuperContracts MCP in Cursor to discover and run them.

---

## Repository layout

```
skill-register/
├── README.md                 # this file — Skill Register overview
├── github-skill/
│   ├── README.md
│   └── github-skill.yaml
├── stripe-refund/
│   ├── README.md
│   └── stripe-refund.yaml
└── supabse-pii/
    ├── README.md
    └── supabase.yaml
```

---

## How a skill is structured

Skill YAML is **policy-only**: endpoints, auth, intents, guardrails, and default. It is not merged into SuperContract YAML when a skill is auto-attached by domain.

| Section | Role |
| --- | --- |
| `domain` | Optional skill domain (e.g. `github.com`) used for discovery / auto-attach |
| `mcp_endpoint` | Upstream MCP base URL (preferred when both MCP and REST are set) |
| `api_endpoint` | Optional REST base URL for non-MCP skills |
| `auth` | How credentials are sent (bearer header, inline `secret`, or `secret_arn`) |
| `intents` | Chat/guardrail action → upstream MCP tool + operation id |
| `guardrails` | Ordered ALLOW / BLOCK rules |
| `default` | BLOCK (or other decision) for anything that does not match a rule |

Intent mapping looks like this:

```yaml
create_refund:
  tool: stripe_api_write
  args:
    stripe_api_operation_id: PostRefunds
```

`run_skill` takes the **intent name** as `action` (`create_refund`), not the upstream tool name (`stripe_api_write`). Guardrails run on that intent; on ALLOW, the mapped tool is invoked.

Anything that does not match a guardrail hits `default: BLOCK`.

---

## Authentication

Demos use bearer auth in the request header. Prefer a registered secret ARN for shared or long-lived skills:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: arn:apilabs:secret:<your-secret-id>
```

Some examples may show an inline `secret` for local demos. Do not commit real production secrets into git.

Without a valid `mcp_endpoint` (or `api_endpoint`) and auth, a skill is discoverable but not executable.

---

## Register a skill

1. Open **Skill Register** on [apilabs.ai](https://apilabs.ai)
2. Create a skill with a stable name (e.g. `github-skill`, `stripe-refund`, `supabase-pii`)
3. Paste the demo YAML as the skill policy
4. Confirm `mcp_endpoint`, `auth`, intents, and guardrails
5. Enable the skill

Repeat per demo (or fork a YAML for your own domain).

---

## Run skills from chat (SuperContracts MCP)

With SuperContracts MCP connected in Cursor:

1. `resolve_skill` — pick a skill when several share a domain (optional `action` / `q` to narrow)
2. `list_skills` — discover skills (filter by domain or `q`)
3. `get_skill` — load saved YAML / endpoints / auth references
4. `list_skill_tools` — when `mcp_endpoint` is set, list intent names and MCP tools
5. `run_skill` — execute with `skill` + `action` + `args` (`mode: validate` checks policy only)

Chat-first flow:

> Prefer `run_skill` for Skill Register actions. Use `invoke_guarded` / `run_contract` for SuperContract YAML workflows; matching Skill Register policies can still auto-attach by domain.

On ALLOW or BLOCK (not validate-only), `run_skill` saves a `Skills/<skill_name>/…__response.json` audit artifact in Explorer.

---

## Mental model

```
User / agent chat
       │
       ▼
  resolve / list / get skill
       │
       ▼
     run_skill(skill, action, args)
       │
       ├─ evaluate guardrails on intent
       │     ├─ BLOCK  → deny + reason (+ audit)
       │     └─ ALLOW  → call mapped MCP/REST tool
       └─ default BLOCK if no rule matches
```

Skills are guarded capabilities, not raw MCP passthrough.

---

## Per-demo docs

- [GitHub skill](./github-skill/README.md) — feature-branch push/PR/edit; block force and `main`/`master`
- [Stripe refund](./stripe-refund/README.md) — list payments; refund cap at $500
- [Supabase PII](./supabse-pii/README.md) — read customers; block PII columns
