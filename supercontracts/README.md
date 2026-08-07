# SuperContracts — Developer Guide

Executable YAML contracts for API workflows, MCP guardrails, approvals, and AI-agent execution. This folder contains **runnable examples** you can copy, adapt, and run from Cursor via the SuperContracts MCP server.

> **New here?** Read the [project overview](../README.md) first. This doc focuses on how contracts work and how to use the examples in this directory.

---

## What SuperContracts Does

SuperContracts turns API behavior into **declarative, executable contracts**:

| Traditional approach | SuperContracts |
|---|---|
| OpenAPI describes endpoints | Contract describes **routes + flows + tests + policy** |
| Postman runs one-off requests | Contract runs **multi-step workflows** with chained data |
| Security lives in separate tools | **Guardrails and approvals** live in the same YAML |
| AI agents call tools directly | Agents call **guarded tools** with ALLOW/BLOCK rules |

A contract is a single YAML file that defines:

1. **What** to call (API routes or MCP tools)
2. **How** to chain steps (flows)
3. **Whether** it passed (tests/assertions)
4. **Who** can do it (guardrails, approvals)

Execution produces **runtime evidence** — run history, responses, and optional AI context — so agents and developers can debug without leaving the IDE.

---

## How It Works

```
┌─────────────┐     MCP tools      ┌──────────────────┐     API      ┌─────────────┐
│   Cursor    │ ────────────────►  │ SuperContracts   │ ───────────► │ Your API /  │
│  (AI agent) │                    │ MCP Server       │              │ MCP service │
└─────────────┘                    └──────────────────┘              └─────────────┘
                                           │
                                           ▼
                                   Auth Vault (secrets)
                                   Run history + evidence
```

1. You write (or use) a contract YAML in the **API Contract Model** on [apilabs.ai](https://apilabs.ai), or pass YAML inline to MCP tools.
2. The **SuperContracts MCP server** connects Cursor to the apilabs runtime.
3. On `run_contract`, the engine resolves auth (via **Secret ARN**), executes flow steps in order, chains response data between steps, and records results.
4. On guarded actions, the engine evaluates **ALLOW/BLOCK** rules before calling upstream systems.

---

## Contract Anatomy

Most API workflow contracts in this repo follow this shape:

| Section | Purpose |
|---|---|
| `api` | Base URL, name, version |
| `auth` | Bearer/OAuth — reference secrets via `secret_arn`, never commit raw tokens |
| `models` | Request/response shapes |
| `routes` | HTTP methods, paths, headers, request/response models |
| `flows` | Ordered steps; later steps reference earlier responses |
| `tests` | Status codes + field assertions against a flow |

**Step chaining** — pass data from one step to the next:

```yaml
inputs:
  id: "eq.{create.response.body.0.id}"
```

**Guarded-service contracts** (MCP policy layer) use a different top-level shape:

| Section | Purpose |
|---|---|
| `supercontract` / `service` | Identity and upstream binding (e.g. GitHub repo) |
| `tools` | Declared tools agents may call (maps to upstream MCP/REST tools) |
| `guardrails` | ALLOW/BLOCK rules evaluated per action |
| `flow` | Optional multi-step guarded execution |

See [`mcp_guardrail_contracts/github_mcp_guardrail.yaml`](./mcp_guardrail_contracts/github_mcp_guardrail.yaml).

---

## Examples in This Folder

| Folder | What it demonstrates |
|---|---|
| [` supabase-crud-local-contracts/`](./%20supabase-crud-local-contracts/) | Chained CRUD workflow against Supabase PostgREST (create → list → get → update → delete) |
| [`supercontracts-mcp-ngrok/`](./supercontracts-mcp-ngrok/) | Local backend exposed via ngrok/Cloudflare tunnel; full property create/publish flow |
| [`mcp_guardrail_contracts/`](./mcp_guardrail_contracts/) | GitHub MCP guardrails — allow branches/PRs, block push to `main` |

Each subfolder has its own README with setup steps.

Additional specs and recipes live at the repo root:

- [`apilabs-supercontracts-DSL-minimal-spec.yaml`](../apilabs-supercontracts-DSL-minimal-spec.yaml) — start here for prototypes
- [`apilabs-supercontracts-DSL-enterprise-spec.yaml`](../apilabs-supercontracts-DSL-enterprise-spec.yaml) — production-grade controls
- [`customer_submitted_contracts/`](../customer_submitted_contracts/) — community examples (refunds, scraping, etc.)
- [`mcp_downloads/`](../mcp_downloads/) — MCP server install guide

---

## Quick Start (Cursor + MCP)

### 1. Auth Vault

1. Log in to [apilabs.ai](https://apilabs.ai)
2. Open **Auth Vault** → create an **MCP Token** and store API credentials
3. Copy the **Secret ARN** (e.g. `arn:apilabs:secret:<id>`) into your contract's `auth.secret_arn`

Secrets stay in the vault; the YAML only holds the ARN reference.

### 2. Connect MCP in Cursor

Add to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "supercontracts": {
      "url": "http://127.0.0.1:8080/mcp"
    }
  }
}
```

Download and start the SuperContracts MCP server from **MCP Downloads** on apilabs.ai. A green indicator in Cursor means tools are discovered.

Full setup: [`mcp_downloads/install_mcp_help.md`](../mcp_downloads/install_mcp_help.md)

### 3. Run a Contract

Typical workflow:

```
list_contracts → get_contract → run_contract → get_run
```

| Tool | What it does |
|---|---|
| `list_contracts` | Find saved contracts by name / folder |
| `get_contract` | Load YAML by `connection_id` |
| `save_contract` | Create or update a contract |
| `run_contract` | Execute a flow or test; returns `run_id` |
| `get_run` | Full run details — assertions, response body, failures |
| `list_test_runs` | Browse run history |
| `resolve_resource` | Resolve an apilabs ARN without exposing secrets |

**Guarded MCP tools:**

| Tool | What it does |
|---|---|
| `list_guarded_tools` | List tools declared in a guarded contract |
| `validate_guarded` | Check ALLOW/BLOCK without executing |
| `invoke_guarded` | Evaluate guardrails, then execute if allowed |

**Approval tools:**

| Tool | What it does |
|---|---|
| `request_approval` | Create a pending approval for sensitive actions |
| `get_approval_status` | Check approval state |
| `decide_approval` | Approve or reject |

Pass `connection_id` to `run_contract` so artifacts are saved next to the YAML:

- `__run.json` — run metadata and step results
- `__response.json` — response bodies
- `__ai_context.md` — auto-generated summary for the next agent turn (optional)

---

## Local Backend Access

If your API runs on `localhost`, expose it with **ngrok** or **Cloudflare Tunnel**, then set `api.base_url` to the public HTTPS URL:

```yaml
api:
  base_url: "https://<your-subdomain>.ngrok-free.dev"
```

See the [ngrok demo README](./supercontracts-mcp-ngrok/README.md).

---

## Two Contract Modes

### API Workflow Contracts

For REST APIs and multi-step integration tests.

- Define `routes` + `flows` + `tests`
- Chain IDs and fields across steps
- Assert status codes and response fields

**Use when:** E2E API testing, integration workflows, AI agents executing business flows.

### Guarded-Service Contracts

For controlling what AI agents can do via MCP.

- Define `tools` + `guardrails` with ALLOW/BLOCK decisions
- Default-deny: anything not explicitly allowed is blocked
- Optional multi-step `flow` with early stop on BLOCK

**Use when:** GitHub agents, Supabase MCP, Slack bots — any case where you need policy before execution.

---

## Minimal Contract Example

```yaml
api:
  base_url: "https://api.example.com"
auth:
  type: bearer
  secret_arn: "arn:apilabs:secret:<your-id>"

routes:
  create_item:
    method: POST
    path: /items
    request:
      body: ItemCreate

flows:
  smoke_test:
    steps:
      - step: create
        action: create_item
        inputs:
          body: { name: "test" }

tests:
  smoke_test:
    execute: smoke_test
    expect:
      create: 201
```

---

## Tips for Developers

- **Never commit real tokens** — use `secret_arn` from Auth Vault
- **Stable step names** — tests reference them in `expect` and `verify`
- **Chaining syntax** — `{step.response.body.field}` pulls data from prior steps
- **Start with a demo** — run Supabase or ngrok example before writing your own
- **Use `generate_ai_context`** on `run_contract` when debugging with Cursor

---

## Learn More

- [Project overview & capabilities](../README.md)
- [Supabase CRUD demo](./%20supabase-crud-local-contracts/README.md)
- [Ngrok / local backend demo](./supercontracts-mcp-ngrok/README.md)
- [MCP install guide](../mcp_downloads/install_mcp_help.md)
- [Minimal DSL spec](../apilabs-supercontracts-DSL-minimal-spec.yaml)
- [Enterprise DSL spec](../apilabs-supercontracts-DSL-enterprise-spec.yaml)
- [Demo video](https://youtu.be/GAt-V7jL4e0?si=lcWUECktH2ZkjOOw) — test workflows from Cursor with auto-generated AI context

## Support

- Website: https://apilabs.ai
- Discord: https://discord.gg/Euh3nxFFeq
