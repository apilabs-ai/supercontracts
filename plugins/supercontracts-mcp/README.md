# SuperContracts MCP plugin

Connect your AI client to the hosted apilabs-ai SuperContracts MCP service.
The service evaluates policies and approvals before it invokes protected API or
MCP actions. This package contains only client configuration and workflow
guidance; it does not contain server code, tokens, or provider credentials.

## Setup

1. In apilabs-ai, create a personal MCP token in **Auth Vault → MCP Access Tokens**.
2. Configure `APILABS_MCP_TOKEN` in your plugin/client settings. Never commit it.
3. Install the plugin and confirm that `supercontracts` exposes tools.
4. Start with a read-only request: `List my saved contracts with their names and connection IDs.`

The configured endpoint is `https://mcp.apilabs.ai/mcp` using Streamable HTTP.

## Included workflows

- `setup` — secure connection and first-read verification.
- `author-contract` — create a contract without placing credentials in YAML.
- `run-protected-action` — validate, execute, and resume an approval safely.
- `investigate-run` — inspect a saved run and its evidence.

## Security

- The MCP token authenticates access to apilabs-ai; it is not a provider credential.
- Tokens can be limited to read, write, execute, and approval permissions. Keep all permissions for normal Cursor use; create a reduced token only for a known limited workflow.
- Store GitHub, Stripe, and other provider credentials in apilabs-ai Auth Vault.
- Never bypass an `approval_required` result or replace the original request when resuming it.
- Use read-only or `validate` workflows first when evaluating a new contract.

For direct client setup and local-bridge guidance, see the repository's
[AI client documentation](../../ai_clients/README.md).
