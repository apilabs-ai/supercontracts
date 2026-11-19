# Stripe Refund Guardrail Profile Demo

A Guardrail Profile policy showing how an agent can list Stripe payments and create refunds through Stripe MCP, with a hard dollar cap on refunds.

---

## What the demo proves

Stripe is exercised through a Guardrail Profile, not a raw MCP tool:

> List payment intents (read-only), then refund — allowed up to $500, blocked above that.

The YAML contains the Stripe MCP endpoint, inline bearer auth, intent mappings, guardrails, and a default deny. Stripe tools live on `https://mcp.stripe.com`. `run_guardrail_profile` evaluates the policy first, then calls the mapped MCP tool, so a coding agent (or you) can see exactly what was allowed or blocked.

Refund amounts in this profile are in **dollars**.

---

## Repository layout

```
stripe/
├── README.md
└── stripe-guardrail-profile.yaml   # version, intents, guardrails, default
```

---

## How the Guardrail Profile is structured

| Section | Role |
| --- | --- |
| `mcp_endpoint` | Stripe MCP base endpoint |
| `auth` | Bearer auth sent in the header |
| `intents` | Chat/guardrail action -> Stripe MCP tool + operation id |
| `guardrails` | Ordered ALLOW / BLOCK rules |
| `default` | BLOCK anything that does not match a rule |

Intent mapping looks like this:

```yaml
create_refund:
  tool: stripe_api_write
  args:
    stripe_api_operation_id: PostRefunds
```

`run_guardrail_profile` takes the intent name as `action` (`create_refund`), not the upstream tool name (`stripe_api_write`).

| Intent | MCP tool | Stripe operation | Policy |
| --- | --- | --- | --- |
| `list_payments` | `stripe_api_read` | `GetPaymentIntents` | Always ALLOW |
| `create_refund` | `stripe_api_write` | `PostRefunds` | ALLOW if `amount <= 500`; BLOCK if `amount > 500` |

Anything else hits `default: BLOCK`.

---

## Authentication

This example authenticates directly in the YAML with a bearer token:

```yaml
auth:
  type: bearer
  in: header
  secret: <your-stripe-secret>
```

That matches `stripe-guardrail-profile.yaml`: requests to Stripe MCP use bearer auth in the request header.

Do not commit real production secrets into git. For shared or long-lived setups, replace the inline secret with your safer secret-management approach before publishing the profile.

---

## Setup

1. Register this profile in **Guardrail Profiles** on [apilabs.ai](https://apilabs.ai) with a name such as `stripe-refund`
2. Paste `stripe-guardrail-profile.yaml` as the Guardrail Profile YAML
3. Confirm the file includes:
   - `mcp_endpoint: https://mcp.stripe.com`
   - bearer `auth` with a Stripe secret
   - intents `list_payments` and `create_refund`
   - guardrails for the refund cap
4. Enable the profile

Without a valid `mcp_endpoint` and auth, the profile is discoverable but not executable.

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_guardrail_profiles` — find this profile
2. `get_guardrail_profile` — load the saved YAML and confirm `mcp_endpoint`, `auth`, and intents
3. `list_guardrail_profile_tools` — confirm intents `list_payments` and `create_refund`
4. `run_guardrail_profile` — execute an intent (`mode: validate` checks policy only)

Examples:

- List payments: `guardrail_profile: stripe-refund`, `action: list_payments`
- Allowed refund: `action: create_refund`, `args.amount: 50`
- Blocked refund: `action: create_refund`, `args.amount: 501`

Pass the **intent name** as `action`. Guardrails run first; Stripe MCP is called only on ALLOW.
