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
Claude sends the configured personal token to this endpoint in the `Authorization: Bearer` header for authenticated MCP requests.

## VS Code and GitHub Copilot

The Registry manifest in `server.json` describes the hosted MCP at
`https://mcp.apilabs.ai/mcp`. Once it is published, search for
`@mcp supercontracts` in a Registry-enabled VS Code or Copilot client, then
provide a personal MCP token when prompted.

For a workspace setup, copy `.vscode/mcp.json` to your workspace and open it
with **MCP: Open Workspace Folder MCP Configuration**. VS Code prompts for the
token securely and sends it as `Authorization: Bearer <token>`. Do not commit a
populated configuration file or token.

GitHub Copilot harness sessions do not receive VS Code `${input:...}` secrets.
For those sessions, configure the same endpoint in the portable Copilot MCP
configuration and provide `APILABS_MCP_TOKEN` in the environment that runs
Copilot:

```json
{
  "mcpServers": {
    "supercontracts": {
      "type": "http",
      "url": "https://mcp.apilabs.ai/mcp",
      "headers": {
        "Authorization": "Bearer ${APILABS_MCP_TOKEN}"
      }
    }
  }
}
```

## MCP Registry publishing

The server is prepared for the GitHub-owned Registry namespace
`io.github.apilabs-ai/supercontracts`. A publisher with access to the
`apilabs-ai` GitHub organization can validate and publish it from this folder:

```bash
brew install mcp-publisher
cd plugins/supercontracts-mcp
mcp-publisher validate server.json
mcp-publisher login github
mcp-publisher publish server.json
```

`validate` makes no publication. Do not run `publish` until the release has
been approved. After publishing, use **MCP: Show Installed Servers** and make
a read-only request such as `List my saved contracts with their names and
connection IDs.` to verify tool discovery and execution.

## Codex package

The root `plugin.json` and `mcp.json` use the portable Agent Plugins format supported by Codex. Build the upload archive from the repository root:

```bash
./scripts/build-codex-package.sh
```

This creates `dist/supercontracts-codex.zip` while preserving the existing bearer-token MCP configuration already used by Cursor and Claude. OpenAI's public submission portal does not currently support API-key connection setup, so public directory submission still requires OAuth 2.1 or an approved authentication exception; local Codex testing can continue with the bearer token.

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
