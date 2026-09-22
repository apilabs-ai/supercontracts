# Stripe Linear Refund Approval Demo

A SuperContracts skill that allows small Stripe refunds and routes refunds above $500 to Linear for approval.

---

## What the demo proves

Stripe is exercised as a guarded skill, not as a raw MCP tool:

> List payments safely, allow refunds up to $500, and require Linear approval for larger refunds.

Refund policy comparisons use `amount_dollars`. A valid refund above $500 returns `APPROVAL_REQUIRED`; it is not executed until the Linear approval is completed and the original request is resumed.

---

## Repository layout

```text
stripe-linear-refund/
├── README.md
└── stripe-linear-refund.yaml
```

---

## How the skill is structured

| Section | Role |
| --- | --- |
| `domain` | Skill domain (`stripe.com`) |
| `mcp_endpoint` | Stripe MCP endpoint |
| `auth` | Bearer credential referenced from the Auth Vault |
| `intents` | Guarded action to Stripe MCP operation mapping |
| `guardrails` | Ordered ALLOW, BLOCK, and APPROVAL_REQUIRED rules |
| `default` | BLOCK anything that does not match a rule |

| Intent | Stripe operation | Policy |
| --- | --- | --- |
| `list_payments` | `GetPaymentIntents` | ALLOW |
| `create_refund` | `PostRefunds` | BLOCK non-positive amounts; ALLOW up to $500; otherwise require Linear approval |

`run_skill` takes the intent name as `action` (`create_refund`), not the upstream tool name (`stripe_api_write`).

---

## Authentication

The YAML refers to a bearer credential stored in the apilabs Auth Vault:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: arn:apilabs:secret
```

Replace the placeholder ARN with the ARN for your Stripe credential. Do not commit the underlying secret.

---

## Setup

1. Configure the Linear approval provider and select the destination team.
2. Register the skill in **Skill Register** on [apilabs.ai](https://apilabs.ai) with a name such as `stripe-linear-refund`.
3. Paste `stripe-linear-refund.yaml` as the skill YAML and replace the placeholder `secret_arn`.
4. Confirm the `list_payments` and `create_refund` intents are available, then enable the skill.

---

## Run it

With SuperContracts MCP connected:

1. Use `list_skills` and select `stripe-linear-refund`.
2. Use `get_skill` and `list_skill_tools` to inspect the saved policy and intents.
3. Call `run_skill` with an intent name. Use `mode: validate` to check the policy without executing.
4. For a refund above $500, wait for the Linear decision and resume the same pending request after approval.

Examples:

- List payments: `action: list_payments`
- Automatic refund: `action: create_refund`, with `amount_dollars: 500` and a non-empty `payment_intent`
- Linear approval: `action: create_refund`, with `amount_dollars: 501` and a non-empty `payment_intent`

The YAML sets `livemode: false` for refund requests.
