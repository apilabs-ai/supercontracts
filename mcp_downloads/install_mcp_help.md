# Configure SuperContracts MCP in Cursor

This guide walks you through configuring the **SuperContracts MCP Server** in Cursor.

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

## 3. Configure Cursor

Open:

```
Cursor → Settings → Features → MCP
```

Click **Add MCP Server**, **or** create the following project configuration file:

```text
.cursor/mcp.json
```

---

## 4. Install the SuperContracts MCP Server

From **apilabs.ai**, navigate to:

```
MCP Downloads
```

Download and start the **SuperContracts MCP Server**.

---

## 5. Configure the MCP Server

Add the following configuration to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "supercontracts": {
      "url": "http://127.0.0.1:8080/mcp"
    }
  }
}
```

---

## 6. Start the MCP Server

Start the SuperContracts MCP Server.

Once running, Cursor automatically discovers the available MCP tools.

✅ A **green status indicator** in Cursor confirms that the MCP server is connected and the tools have been successfully discovered.

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
