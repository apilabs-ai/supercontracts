# Claude Code

## Configure SuperContracts MCP

Run from the project where you use Claude Code:

```bash
claude mcp add --transport http supercontracts http://127.0.0.1:8080/mcp
claude mcp list
```

Add the MCP bearer token through your supported Claude Code authentication/header configuration. Do not place a real token in a committed project file.

## Verify installation

In Claude Code, run `/mcp` and confirm that `supercontracts` is connected and exposes tools. Then make a safe read-only request:

```text
Use SuperContracts to list my saved contracts with their names and connection IDs.
```

Continue with [Run your first protected action](../quick_start/run-your-first-protected-action.md).

[Back to AI Clients](./README.md)
