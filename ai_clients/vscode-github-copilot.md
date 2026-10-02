# VS Code / GitHub Copilot

## Configure SuperContracts MCP

Create `.vscode/mcp.json` in your project:

```json
{
  "servers": {
    "supercontracts": {
      "type": "http",
      "url": "http://127.0.0.1:8080/mcp",
      "headers": {
        "Authorization": "Bearer ${input:apilabs-mcp-token}"
      }
    }
  },
  "inputs": [
    {
      "id": "apilabs-mcp-token",
      "type": "promptString",
      "description": "API Labs MCP token",
      "password": true
    }
  ]
}
```

Open Copilot Chat in Agent mode and enable `supercontracts` in the tools picker.

## Verify installation

Confirm that the SuperContracts tools are visible, then make a safe read-only request:

```text
Use SuperContracts to list my saved contracts with their names and connection IDs.
```

Continue with [Run your first protected action](../quick_start/run-your-first-protected-action.md).

[Back to AI Clients](./README.md)
