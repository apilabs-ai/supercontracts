# Claude Code

## Hosted MCP — Recommended

Run from the project where you use Claude Code:

```bash
claude mcp add --transport http supercontracts https://mcp.apilabs.ai/mcp \
  --header "Authorization: Bearer <YOUR_API_LABS_MCP_TOKEN>"
claude mcp list
```

## Local MCP — Optional

Download, unzip, and start the local SuperContracts MCP release. Confirm `http://127.0.0.1:8080/health` is healthy, then run:

```bash
claude mcp add --transport http supercontracts http://127.0.0.1:8080/mcp \
  --header "Authorization: Bearer <YOUR_API_LABS_MCP_TOKEN>"
claude mcp list
```

Do not place a live token in a committed project configuration. Claude Code also supports environment-variable expansion in `.mcp.json` headers when you want to keep the token outside the file.

## Verify installation

In Claude Code, run `/mcp` and confirm that `supercontracts` is connected and exposes tools. Then make a safe read-only request:

```text
Use SuperContracts to list my saved contracts with their names and connection IDs.
```

Continue with [Run your first protected action](../quick_start/run-your-first-protected-action.md).

[Back to AI Clients](./README.md)
