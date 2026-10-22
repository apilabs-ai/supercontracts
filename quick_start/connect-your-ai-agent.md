# Connect your AI Agent

SuperContracts supports two connection modes. The hosted MCP service is recommended for most users; the local bridge remains available when execution must stay on a user-controlled machine or network.

| | Hosted MCP | Local MCP |
| --- | --- | --- |
| Recommended for | Most users and fastest onboarding | Private networks, local development, restricted environments |
| MCP URL | `https://mcp.apilabs.ai/mcp` | `http://127.0.0.1:8080/mcp` |
| Download required | No | Yes |
| Local process required | No | Yes |
| MCP token required | Yes | Yes |
| Provider credentials | apilabs-ai Auth Vault | apilabs-ai Auth Vault |
| Updates | Managed by apilabs-ai | Download new releases when needed |

## Hosted MCP — Recommended

1. Sign in to [apilabs.ai](https://apilabs.ai).
2. Open **Auth Vault → MCP Access Tokens**.
3. Generate an MCP token and copy it when it is displayed.
4. Copy the hosted MCP configuration or configure your client with:

```text
https://mcp.apilabs.ai/mcp
```

5. Reload or reconnect the client.
6. Confirm that the SuperContracts tool list is populated.
7. Make a safe read-only call such as `list_contracts`.

No MCP binary, local process, port, or health check is required for hosted setup.

## Local MCP — Optional

1. Generate an MCP token from **Auth Vault → MCP Access Tokens**.
2. Follow the [optional local MCP installation guide](../mcp_downloads/install_mcp_help.md) to download the latest release for your operating system.
3. Unzip it and run the binary from the extracted folder.
4. Confirm the local bridge is healthy:

```bash
curl http://127.0.0.1:8080/health
```

5. Configure your client with:

```text
http://127.0.0.1:8080/mcp
```

6. Reload or reconnect the client, confirm the tool list is populated, and make a safe read-only call such as `list_contracts`.

Release binaries use `https://app.apilabs.ai` as the apilabs-ai backend. Developers running the bridge from source can override `APILABS_BASE_URL` when working against another backend.

Choose your client for exact hosted and local configuration:

- [Cursor](../ai_clients/cursor.md)
- [Claude Code](../ai_clients/claude-code.md)
- [Codex](../ai_clients/codex.md)
- [VS Code / GitHub Copilot](../ai_clients/vscode-github-copilot.md)

> Configure only one `supercontracts` server entry in a client. Do not keep hosted and local entries with the same name enabled at the same time.

Next: [Authenticate](./authenticate.md)

[Back to Quick Start](./README.md)
