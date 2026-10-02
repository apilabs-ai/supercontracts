# Codex

## Configure SuperContracts MCP

In one terminal, export the MCP token. In the project terminal, register and verify the server:

```bash
export APILABS_MCP_TOKEN="<YOUR_API_LABS_MCP_TOKEN>"
codex mcp add supercontracts \
  --url http://127.0.0.1:8080/mcp \
  --bearer-token-env-var APILABS_MCP_TOKEN
codex mcp list
```

Codex CLI and the Codex IDE extension share MCP configuration.

## Verify installation

Confirm that `codex mcp list` shows `supercontracts` as enabled. Launch Codex and make a safe read-only request:

```text
Use SuperContracts to list my saved contracts with their names and connection IDs.
```

Continue with [Run your first protected action](../quick_start/run-your-first-protected-action.md).

[Back to AI Clients](./README.md)
