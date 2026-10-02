<p align="center">
  <img src="images/apilabs_ai_supercontracts_logo.png" alt="apilabs.ai SuperContracts" width="400">
</p>

<h1 align="center">SuperContracts</h1>

<p align="center">
  <strong>Policy-as-code guardrails for APIs, MCP tools, workflows, and AI agents.</strong>
</p>

SuperContracts are executable YAML contracts that control what AI agents can do, test multi-step API workflows, require approval for sensitive actions, and retain runtime evidence.

They work with AI clients such as Cursor, Claude Code, Codex, and VS Code with GitHub Copilot. SuperContracts is the contract and guardrail layer—not another agent framework.

```text
AI client
    │
    ▼
SuperContracts MCP
    │
    ├── Contract and identity
    ├── Policy and risk
    └── Approval and evidence
    │
    ▼
ALLOW / BLOCK / REQUIRE APPROVAL
    │
    ▼
API, MCP tool, or SaaS provider
```

The agent requests an action. SuperContracts evaluates the applicable policy before the action reaches the connected system.

## Quickstart

Go from a new installation to a protected agent action in three steps.

### 1. Connect your AI client

1. Sign in to [apilabs.ai](https://apilabs.ai).
2. Open **Auth Vault**, create an **MCP Token**, and download the SuperContracts MCP bridge from **MCP Downloads**.
3. Start the bridge, then confirm it is healthy:

```bash
curl http://127.0.0.1:8080/health
```

4. Connect your client to the local Streamable HTTP endpoint:

```text
http://127.0.0.1:8080/mcp
```

<details>
<summary><strong>Cursor</strong></summary>

Create `.cursor/mcp.json` in your project:

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

Reload Cursor, open **Settings → MCP**, and confirm that `supercontracts` is connected and exposes tools.

</details>

<details>
<summary><strong>Claude Code</strong></summary>

Run from the project where you use Claude Code:

```bash
claude mcp add --transport http supercontracts http://127.0.0.1:8080/mcp
claude mcp list
```

Add the MCP bearer token through your supported Claude Code authentication/header configuration. Do not place a real token in a committed project file.

</details>

<details>
<summary><strong>Codex</strong></summary>

In one terminal, export the MCP token. In the project terminal, register and verify the server:

```bash
export APILABS_MCP_TOKEN="<YOUR_API_LABS_MCP_TOKEN>"
codex mcp add supercontracts \
  --url http://127.0.0.1:8080/mcp \
  --bearer-token-env-var APILABS_MCP_TOKEN
codex mcp list
```

Codex CLI and the Codex IDE extension share MCP configuration.

</details>

<details>
<summary><strong>VS Code / GitHub Copilot</strong></summary>

Create `.vscode/mcp.json`:

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

</details>

> MCP authentication and provider authentication are separate. The MCP token connects your AI client to SuperContracts. GitHub, Stripe, Slack, and other provider credentials are stored separately in Auth Vault and referenced from contracts. Never commit either kind of secret.

### 2. Choose your first SuperContract

Start with one of these read-only examples:

| Provider | Ask your AI agent | Contract |
| --- | --- | --- |
| GitHub | “List my repositories.” | [`GitHub → Read`](./quick_start/github-read-repositories.yml) |
| Gmail | “Show my 5 most recent emails.” | [`Gmail → Read`](./quick_start/gmail-read-emails.yml) |
| Google Calendar | “Show my upcoming events.” | [`Google Calendar → Read`](./quick_start/google-calendar-read-events.yml) |

Each contract makes one safe provider request and checks for a successful response. Follow the [Quick Start examples guide](./quick_start/) to connect the required provider account and save the contract in API Contract Model.

### 3. Run your first SuperContract

Use the GitHub example for the first run. Ask your AI client:

```text
Use SuperContracts to find the saved quick-start contract for reading GitHub repositories.
Call get_contract and show me its test names. Do not run it yet.
```

After it returns `github_read_repositories`, ask:

```text
Run the github_read_repositories test from the contract you just loaded.
Use the complete contract_yaml returned by get_contract and the same connection_id.
Show the expected-versus-actual assertion and the repositories returned.
```

The expected result is:

```text
Step: repositories
Expected status: 200
Actual status: 200
Result: PASS
```

The agent should follow `list_contracts → get_contract → run_contract → get_run`. Passing the complete returned YAML and the same `connection_id` keeps the run evidence associated with the saved contract.

## What can you build?

### Agentic security guardrails

Place deterministic ALLOW/BLOCK policy between an agent and an MCP or API tool. Use default-deny rules, constrain arguments, and validate an action without executing it.

- [GitHub MCP guardrail example](./supercontracts/mcp_guardrail_contracts/)
- [GitHub, Stripe, and Supabase skill policies](./skills/)

### Approval workflows

Pause sensitive actions for human review and continue the original request after a decision. The examples cover GitHub merge approval through Slack and Stripe refund approval through Linear or Jira.

- [Approval workflow examples](./supercontracts/approval-workflows/)

### Multi-step API testing

Define routes, chain response data between steps, assert status codes and fields, and keep the resulting evidence with the contract.

- [GitHub API testing](./api-testing-supercontracts/github-api-testing/)
- [Stripe API testing](./api-testing-supercontracts/stripe-api-testing/)
- [Supabase API testing](./api-testing-supercontracts/supabase-api-testing/)
- [Supabase CRUD workflow](./supercontracts/%20supabase-crud-local-contracts/)

### SaaS API workflows

Compose guarded workflows across APIs and MCP providers without embedding provider secrets in YAML. Contracts can coordinate GitHub, Slack, Stripe, Jira, Linear, Supabase, and other services exposed through supported connectors.

- [Local API workflow through ngrok](./supercontracts/supercontracts-mcp-ngrok/)
- [Customer-submitted contracts](./customer_submitted_contracts/)

## SuperContracts MCP tools

| Area | Tools | Purpose |
| --- | --- | --- |
| Contracts | `list_contracts`, `get_contract`, `save_contract` | Discover, load, and store contract YAML |
| Execution | `run_contract`, `get_run`, `list_test_runs` | Run tests/workflows and inspect evidence |
| Resources | `resolve_resource` | Resolve API Labs resource metadata without exposing secret values |
| Guardrails | `list_guarded_tools`, `validate_guarded`, `invoke_guarded` | Inspect policy, validate without side effects, or execute after evaluation |
| Skills | `resolve_skill`, `list_skills`, `get_skill`, `list_skill_tools`, `run_skill` | Discover and run reusable provider policies by intent |
| Approvals | `request_approval`, `get_approval_status`, `decide_approval` | Create, inspect, and decide approval requests |

For saved API contracts, use this sequence:

```text
list_contracts → get_contract → run_contract → get_run
```

Pass the complete `contract_yaml` returned by `get_contract` and the same `connection_id` to `run_contract`. This preserves the saved contract context and its run artifacts.

For Skill Register actions, use:

```text
resolve_skill → get_skill → list_skill_tools → run_skill
```

`run_skill.action` is the contract's intent name—not the upstream provider tool name. Use `mode: validate` before enabling side effects.

## Runtime evidence

SuperContracts can retain the request, policy decision, step results, assertions, response data, approval state, and optional AI context. This makes an agent action reviewable after execution instead of leaving only a chat transcript.

When a saved API contract is run with its `connection_id`, artifacts can include:

- `__run.json` — run metadata and step results
- `__response.json` — response bodies
- `__ai_context.md` — an optional summary for the next agent turn

## Repository guide

| Path | Contents |
| --- | --- |
| [`supercontracts/`](./supercontracts/) | Developer guide, guarded-service contracts, approvals, and workflow examples |
| [`skills/`](./skills/) | Reusable GitHub, Stripe, and Supabase Skill Register policies |
| [`api-testing-supercontracts/`](./api-testing-supercontracts/) | Provider-focused API test suites |
| [`mcp_downloads/`](./mcp_downloads/) | Local MCP bridge downloads and Cursor setup guide |
| [`apilabs-supercontracts-spec.yml`](./apilabs-supercontracts-spec.yml) | SuperContracts specification |
| [`supercontracts-expression-grammar.md`](./supercontracts-expression-grammar.md) | Expression grammar reference |

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Client cannot connect | Start the local bridge and confirm `curl http://127.0.0.1:8080/health` succeeds |
| Port `8080` is already in use | Check `/health` first; an existing SuperContracts bridge may already be running |
| `401`, `403`, or `Missing or malformed JWT` | Confirm the MCP token is present, unexpired, and sent as `Authorization: Bearer <token>` |
| Client shows connected but no tools | Reload/reconnect the client, inspect the tool list, and make a safe read-only call such as `list_contracts` |
| Provider action cannot authenticate | Configure that provider separately in Auth Vault; the MCP token does not authenticate GitHub, Stripe, or other providers |

See the [full MCP installation guide](./mcp_downloads/install_mcp_help.md) for local setup details.

## Demo

[Test workflow APIs with AI agent contracts and auto-generated AI context](https://youtu.be/GAt-V7jL4e0?si=lcWUECktH2ZkjOOw)

The demo shows a contract run from an AI IDE, saved response/run artifacts, and AI context used to continue debugging.

## Security notes

- Never commit MCP tokens, provider access tokens, API keys, OAuth credentials, approval tokens, or reusable file ARNs.
- Use Auth Vault secret references in contracts.
- Prefer `validate_guarded` or `run_skill` with `mode: validate` before real side effects.
- Use owned or disposable infrastructure for demos.
- Review contract scope and default-deny behavior before enabling a workflow.

## Specification and license

- [SuperContracts specification](./apilabs-supercontracts-spec.yml)
- [Expression grammar](./supercontracts-expression-grammar.md)
- Licensed under [Apache-2.0](./LICENSE)

Questions and community support: [Discord](https://discord.gg/Euh3nxFFeq)
