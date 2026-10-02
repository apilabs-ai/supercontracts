# Connect your AI Agent

1. Sign in to [apilabs.ai](https://apilabs.ai).
2. Open **Auth Vault**, create an **MCP Token**, and download the SuperContracts MCP bridge from **MCP Downloads**.
3. Start the bridge, then confirm it is healthy:

```bash
curl http://127.0.0.1:8080/health
```

4. Connect your AI client to the local Streamable HTTP endpoint:

```text
http://127.0.0.1:8080/mcp
```

Choose your client for exact configuration:

- [Cursor](../ai_clients/cursor.md)
- [Claude Code](../ai_clients/claude-code.md)
- [Codex](../ai_clients/codex.md)
- [VS Code / GitHub Copilot](../ai_clients/vscode-github-copilot.md)

A connected status alone is not enough. Reload or reconnect the client, verify that the tool list is populated, and make a safe read-only call such as `list_contracts`.

Next: [Authenticate](./authenticate.md)

[Back to Quick Start](./README.md)
