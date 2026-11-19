# Guardrail Profiles

Guardrail Profiles turn third-party MCP (or REST) APIs into **guarded capabilities** that agents can discover and run from chat — without giving them raw, unbounded tool access.

You register a named Guardrail Profile on [apilabs.ai](https://apilabs.ai) with YAML that defines:

- Which MCP/REST endpoint to call
- How to authenticate
- Which **intents** (chat actions) map to upstream tools
- Ordered **guardrails** (ALLOW / BLOCK)
- A **default deny** for anything that does not match

`run_guardrail_profile` evaluates the policy first, then calls the mapped tool only on ALLOW. Agents (or you) see exactly what was allowed or blocked.

---

## What this folder is

Ready-to-paste Guardrail Profile demos. Each subdirectory is one profile: a YAML policy plus a tool-specific README.

| Demo | Domain idea | What the policy proves |
| --- | --- | --- |
| [GitHub](./github/) | GitHub Copilot MCP | Push / edit on feature branches and open PRs — allowed; force push or writes to `main` / `master` — blocked |
| [Stripe refund](./stripe/) | Stripe MCP | List payments; refund up to $500 — allowed; above $500 — blocked |
| [Supabase PII](./supabse/) | Supabase MCP | Read customer rows — allowed for safe columns; `credit_card` / `ssn` — blocked |

Use these as templates when registering Guardrail Profiles, then connect SuperContracts MCP in Cursor to discover and run them.

---

## Repository layout

```
guardrail_profiles/
├── README.md                 # this file — Guardrail Profile overview
├── github/
│   ├── README.md
│   └── github-guardrail-profile.yaml
├── stripe/
│   ├── README.md
│   └── stripe-guardrail-profile.yaml
└── supabse-pii/
    ├── README.md
    └── supabase-guardrail-profile.yaml
```

---

## How a Guardrail Profile is structured

Guardrail Profile YAML is **policy-only**: endpoints, auth, intents, guardrails, and default. It is not merged into SuperContract YAML when a profile is auto-attached by domain.

| Section | Role |
| --- | --- |
| `domain` | Optional profile domain (e.g. `github.com`) used for discovery / auto-attach |
| `mcp_endpoint` | Upstream MCP base URL (preferred when both MCP and REST are set) |
| `api_endpoint` | Optional REST base URL for non-MCP profiles |
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

`run_guardrail_profile` takes the **intent name** as `action` (`create_refund`), not the upstream tool name (`stripe_api_write`). Guardrails run on that intent; on ALLOW, the mapped tool is invoked.

Anything that does not match a guardrail hits `default: BLOCK`.

---

## Authentication

Demos use bearer auth in the request header. Prefer a registered secret ARN for shared or long-lived profiles:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: arn:apilabs:secret:<your-secret-id>
```

Some examples may show an inline `secret` for local demos. Do not commit real production secrets into git.

Without a valid `mcp_endpoint` (or `api_endpoint`) and auth, a profile is discoverable but not executable.

---

## Register a Guardrail Profile

1. Open **Guardrail Profiles** on [apilabs.ai](https://apilabs.ai)
2. Create a profile with a stable name (e.g. `github-profile`, `stripe-refund`, `supabase-pii`)
3. Paste the demo YAML as the Guardrail Profile policy
4. Confirm `mcp_endpoint`, `auth`, intents, and guardrails
5. Enable the profile

Repeat per demo (or fork a YAML for your own domain).

---

## Run Guardrail Profiles from chat (SuperContracts MCP)

With SuperContracts MCP connected in Cursor:

1. `resolve_guardrail_profile` — pick a profile when several share a domain (optional `action` / `q` to narrow)
2. `list_guardrail_profiles` — discover profiles (filter by domain or `q`)
3. `get_guardrail_profile` — load saved YAML / endpoints / auth references
4. `list_guardrail_profile_tools` — when `mcp_endpoint` is set, list intent names and MCP tools
5. `run_guardrail_profile` — execute with `guardrail_profile` + `action` + `args` (`mode: validate` checks policy only)

Chat-first flow:

> Prefer `run_guardrail_profile` for Guardrail Profile actions. Use `invoke_guarded` / `run_contract` for SuperContract YAML workflows; matching Guardrail Profiles can still auto-attach by domain.

On ALLOW or BLOCK (not validate-only), `run_guardrail_profile` saves a `Guardrail Profiles/<guardrail_profile_name>/…__response.json` audit artifact in Explorer.

---

## Mental model

```
User / agent chat
       │
       ▼
  resolve / list / get profile
       │
       ▼
 run_guardrail_profile(guardrail_profile, action, args)
       │
       ├─ evaluate guardrails on intent
       │     ├─ BLOCK  → deny + reason (+ audit)
       │     └─ ALLOW  → call mapped MCP/REST tool
       └─ default BLOCK if no rule matches
```

Guardrail Profiles are guarded capabilities, not raw MCP passthrough.

---

## Per-demo docs

- [GitHub Guardrail Profile](./github/README.md) — feature-branch push/PR/edit; block force and `main`/`master`
- [Stripe refund Guardrail Profile](./stripe/README.md) — list payments; refund cap at $500
- [Supabase PII Guardrail Profile](./supabse/README.md) — read customers; block PII columns
