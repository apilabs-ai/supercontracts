# Authenticate

SuperContracts uses two separate authentication layers:

1. **MCP authentication** connects your AI client to SuperContracts. Create an **MCP Token** in API Labs Auth Vault and configure it in your AI client.
2. **Provider authentication** gives a contract access to GitHub, Gmail, Google Calendar, Stripe, Slack, or another provider. Store that credential separately in Auth Vault and reference its Secret ARN from the contract.

Never commit MCP tokens, provider access tokens, API keys, OAuth credentials, approval tokens, or real Secret ARNs.

## Prepare a Quick Start contract

1. In API Labs **Auth Vault**, connect the provider you want to use.
2. Copy the provider credential ARN into the contract's `auth.secret_arn` before saving it in API Contract Model.
3. Save the YAML in **API Contract Model** and keep its returned `connection_id`.
4. For Google Calendar, replace `CHANGE_ME_CURRENT_RFC3339_TIMESTAMP` with the current time in RFC3339 format, for example `2026-10-02T10:00:00+05:30`.

Required access:

- GitHub: token with permission to read the authenticated user's repositories.
- Gmail: Google OAuth with `gmail.readonly` access.
- Google Calendar: Google OAuth with Calendar read-only access.

## Authentication troubleshooting

| Symptom | Check |
| --- | --- |
| `401`, `403`, or `Missing or malformed JWT` | Confirm the MCP token is present, unexpired, and sent as `Authorization: Bearer <token>` |
| Provider action cannot authenticate | Configure that provider separately in Auth Vault; the MCP token does not authenticate GitHub, Gmail, or other providers |

Next: [Run your first protected action](./run-your-first-protected-action.md)

[Back to Quick Start](./README.md)
