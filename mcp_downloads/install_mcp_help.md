# Optional Local SuperContracts MCP Setup for Cursor

Most users should connect directly to the hosted SuperContracts MCP service and do not need to download or run a local server:

```text
https://mcp.apilabs.ai/mcp
```

See the [Cursor client guide](../ai_clients/cursor.md#hosted-mcp--recommended) for the recommended hosted configuration.

Use this guide when you specifically need the **local SuperContracts MCP bridge** for private-network access, local development, restricted environments, or customer-controlled execution.

---

## Prerequisites

Before getting started, ensure you have:

- A **Cursor** installation
- An **apilabs.ai** account
- The **SuperContracts MCP Server**
- (Optional) **Cloudflare Tunnel** or **Ngrok** for exposing local services

---

## 1. Create an MCP Token

1. Log in to **https://apilabs.ai**
2. Open **Auth Vault**
3. Create a new **MCP Token**

> **Auth Vault** is a centralized vault for securely creating and managing:
>
> - OAuth credentials
> - API Keys
> - MCP Tokens
>
> It also lets you copy the generated **ARN**, which can be injected directly into your SuperContracts.

---

## 2. Expose Local Services (Optional)

If your contracts or remote systems need to access services running on your local machine, expose them using one of the following:

- Cloudflare Tunnel
- Ngrok

This provides a secure public URL for local development.

---

## 3. Configure Cursor for Local MCP

Open:

```
Cursor → Settings → Features → MCP
```

Click **Add MCP Server**, **or** create the following project configuration file:

```text
.cursor/mcp.json
```

---

## 4. Install the Local SuperContracts MCP Server

From **apilabs.ai**, navigate to:

```
MCP Downloads
```

Download and start the **SuperContracts MCP Server**.

---

## 5. Configure the Local MCP Server

Add the following configuration to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "supercontracts": {
      "url": "http://127.0.0.1:8080/mcp",
      "headers": {
        "Authorization": "Bearer <YOUR_API_LABS_MCP_TOKEN>"
      }
    }
  }
}
```

---

## 6. Start the MCP Server

Start the SuperContracts MCP Server.

Once running, Cursor automatically discovers the available MCP tools.

✅ A **green status indicator** confirms the connection. Also open the server configuration and verify that the tool list is populated; connection status alone is not sufficient verification.

---

# Next Steps

After the MCP server is connected, you can:

- Execute SuperContracts directly from Cursor
- Run executable API and MCP contracts
- Validate AI agent actions using guardrails
- Generate execution evidence
- Enforce human approval workflows
- Test complete end-to-end API, MCP, and AI agent workflows

---

## Learn More

- **Website:** https://apilabs.ai
- **Auth Vault:** Create and securely manage OAuth credentials, API Keys, MCP Tokens, and Contract Secrets
- **MCP Downloads:** Download the latest SuperContracts MCP Server
- **Documentation:** See the project documentation for contract examples and guides
