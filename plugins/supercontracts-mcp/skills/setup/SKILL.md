---
name: setup
description: Connect SuperContracts securely and verify the first read-only MCP request.
---

Help the user connect the SuperContracts MCP server without exposing a token.

1. Confirm the hosted endpoint is `https://mcp.apilabs.ai/mcp`.
2. Direct the user to create a personal token in apilabs-ai Auth Vault and configure it as `APILABS_MCP_TOKEN` in their client or plugin settings. Never ask them to paste the token into chat or save it in a repository file.
3. Confirm the `supercontracts` server is connected and its tool list is populated.
4. Verify with a read-only request: list saved contracts with names and connection IDs.
5. If authentication fails, ask the user to verify that their personal token is active and sent as a Bearer token. Do not suggest static shared tokens.

Provider credentials are separate from MCP authentication and belong in apilabs-ai Auth Vault.
