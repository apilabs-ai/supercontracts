# Authenticate

SuperContracts uses two separate authentication layers:

1. **MCP authentication** connects your AI client to the hosted or local SuperContracts MCP service.
2. **Provider authentication** gives a contract access to GitHub, Gmail, Google Calendar, Stripe, Slack, or another provider.

## MCP authentication

Open **API Labs → Auth Vault → MCP Access Tokens**, enter a token name, and generate a token.

- The token is displayed only when it is generated. Copy and store it securely.
- Current MCP tokens expire nightly.
- Hosted and local MCP connections use the same token format.
- Send it as `Authorization: Bearer <mcp_token>`.
- Auth Vault shows token status, expiry, and last-used information.
- Revoking a token immediately prevents clients using it from accessing protected API Labs data and actions.

Never commit an MCP token or a client configuration containing a live token.

## Provider authentication

The MCP token does not authenticate GitHub, Gmail, Google Calendar, Stripe, or another provider. Connect those provider credentials separately in Auth Vault and reference their Secret ARN from the contract.

Never commit provider access tokens, API keys, OAuth credentials, approval tokens, or real Secret ARNs.

## Prepare a Quick Start contract

1. In API Labs **Auth Vault**, connect the provider you want to use.
2. Copy the provider credential ARN into the contract's `auth.secret_arn` before saving it in API Contract Model.
3. Save the YAML in **API Contract Model** and keep its returned `connection_id`.
4. For Google Calendar, replace `CHANGE_ME_CURRENT_RFC3339_TIMESTAMP` with the current time in RFC3339 format, for example `2026-10-15T12:00:00+05:30`.

Required access:

- GitHub: token with permission to read the authenticated user's repositories.
- Gmail: Google OAuth with `gmail.readonly` access.
- Google Calendar: Google OAuth with Calendar read-only access.

## Authentication troubleshooting

| Symptom | Check |
| --- | --- |
| `401`, `403`, or `Missing or malformed JWT` | Confirm the MCP token is active and sent with the `Bearer ` prefix |
| A previously working client stops | Check whether its nightly token expired or was revoked, then generate a new token |
| Provider action cannot authenticate | Configure that provider separately in Auth Vault; the MCP token is not a provider credential |

Next: [Run your first protected action](./run-your-first-protected-action.md)

[Back to Quick Start](./README.md)
