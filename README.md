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

## Documentation

### 🚀 Quick Start

- [What are SuperContracts?](./quick_start/what-are-supercontracts.md)
- [Connect your AI Agent](./quick_start/connect-your-ai-agent.md)
- [Authenticate](./quick_start/authenticate.md)
- [Run your first protected action](./quick_start/run-your-first-protected-action.md)

### 🤖 AI Clients

- [Cursor](./ai_clients/cursor.md)
- [Claude Code](./ai_clients/claude-code.md)
- [Codex](./ai_clients/codex.md)
- [VS Code / GitHub Copilot](./ai_clients/vscode-github-copilot.md)

Start with the [Quick Start overview](./quick_start/). It takes you from installation to a protected, read-only GitHub action and includes screenshots plus a complete Cursor video.

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
| [`quick_start/`](./quick_start/) | Four-part Quick Start plus GitHub, Gmail, and Google Calendar contracts |
| [`ai_clients/`](./ai_clients/) | Cursor, Claude Code, Codex, and VS Code / GitHub Copilot setup |
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
