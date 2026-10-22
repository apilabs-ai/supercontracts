# VS Code / GitHub Copilot

## Hosted MCP — Recommended

Create `.vscode/mcp.json` in your project:

```json
{
  "servers": {
    "supercontracts": {
      "type": "http",
      "url": "https://mcp.apilabs.ai/mcp",
      "headers": {
        "Authorization": "Bearer ${input:apilabs-mcp-token}"
      }
    }
  },
  "inputs": [
    {
      "id": "apilabs-mcp-token",
      "type": "promptString",
      "description": "apilabs-ai MCP token",
      "password": true
    }
  ]
}
```

## Local MCP — Optional

Download, unzip, and start the local SuperContracts MCP release. Confirm `http://127.0.0.1:8080/health` is healthy, then use the same configuration with:

```json
"url": "http://127.0.0.1:8080/mcp"
```

The `${input:apilabs-mcp-token}` input prevents a live token from being committed in the configuration file.

## Verify installation

Open Copilot Chat in Agent mode, enable `supercontracts` in the tools picker, and confirm its tools are visible. Then make a safe read-only request:

```text
Use SuperContracts to list my saved contracts with their names and connection IDs.
```

Continue with [Run your first protected action](../quick_start/run-your-first-protected-action.md).

[Back to AI Clients](./README.md)
