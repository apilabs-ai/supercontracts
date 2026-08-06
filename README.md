<p align="center">
  <img src="apilabs_ai_supercontracts.png"
       alt="apilabs.ai SuperContracts"
       width="400">
</p>

<h1 align="center">SuperContracts</h1>

<p align="center">
  Executable contracts and guardrails for APIs, MCPs, and AI agents.
</p>

Open Contract Spec defines how software systems should be called, tested, secured, approved, and executed — in a format humans, tools, and AI agents can understand.

Traditional API specs describe endpoints. **Open Contract Spec describes execution, policy, and safety.**

---

## Why

API operations are fragmented.

* **OpenAPI** documents endpoints.
* **Postman<sup>TM</sup>** tests requests.
* **CI** validates changes.
* **Workflow tools** automate actions.
* **Security tools** enforce policies.
* **Jira<sup>TM</sup>, Slack<sup>TM</sup>, and email** handle approvals.
* **Logs** capture audits.

The result is drift, duplicated work, weak governance, and unclear ownership.

That was inefficient for developers.
With AI agents and MCP tools executing real actions, it becomes a security risk.

Agents can touch money, data, code, infrastructure, and customer operations. Without guardrails, they can trigger unauthorized access, destructive changes, privilege misuse, prompt-injection exploits, or unapproved production actions.

**Open Contract Spec<sup>TM</sup> brings docs, tests, workflows, approvals, guardrails, and audit trails into one executable contract.**


---

## What It Covers

* APIs and MCP tools
* Auth and environments
* Workflows and tests
* Approvals and guardrails
* AI-agent permissions
* Runtime evidence

---

# SuperContracts Core Capabilities & Code Recipes

## Cursor™ MCP Integration & Runtime Evidence

Connect SuperContracts to Cursor through MCP so your AI agent can discover contracts, execute workflows, inspect test history, and receive auto-generated AI context — without leaving the IDE.

Every tool call runs through the same guardrails, approvals, and evidence capture defined in your contract.

### Configure SuperContracts MCP in Cursor

1. Open **Cursor Settings → Features → MCP** and click **Add MCP Server**, or add a project-level `.cursor/mcp.json` file.
2. Download the SuperContracts MCP server from MCP Downloads, or paste the config below after starting the local MCP server:

```json
{
  "mcpServers": {
    "supercontracts": {
      "url": "http://127.0.0.1:8080/mcp"
    }
  }
}
```

3. Start the SuperContracts MCP server, get MCP token from https://apilabs.ai 'Auth Vault'. A green indicator in Cursor confirms the tools are discovered.

### Published MCP Tools

| Tool | Purpose |
| --- | --- |
| `list_contracts` | List saved contract YAML files in API Contract Model, including nested explorer folders |
| `get_contract` | Load the YAML content of a saved contract by `connection_id` |
| `save_contract` | Create or update a contract YAML file in API Contract Model |
| `run_contract` | Execute a contract inline — returns `run_id`, response, and optional AI context |
| `list_test_runs` | Browse recent contract test run history with archive and status filters |
| `get_run` | Fetch full run details including assertions, response body, and AI context |
| `resolve_resource` | Resolve an apilabs ARN (file, secret, or method) to metadata without exposing secrets |

**Typical flow:** `list_contracts` → `get_contract` → `run_contract` → `get_run`

### Examples

Walk through a full Cursor session using an app-talk contract that syncs Google Forms submissions into Zoho CRM Leads:

[google_forms_zoho_leads.yaml](https://github.com/apilabs-ai/apilabs_api_contract_recipes_pvt/blob/main/app_talk_contract/google_forms_zoho_leads.yaml)

That contract defines an `apptalk` mapping (form fields → Zoho Lead fields), an `e2e` flow (`validate` → `create_config` → `test_sync`), and a test that asserts `test_sync.response.body.success == true`.

1. Call `list_contracts` to locate `google_forms_zoho_leads`.
2. Call `get_contract` with the contract’s `connection_id` to load the full YAML.
3. Call `run_contract` to execute the `e2e` flow (`validate` → `create_config` → `test_sync`).
4. Call `get_run` with the returned `run_id` to review assertions, response body, and failures.

Optionally enable `generate_ai_context` on `run_contract` to produce an `ai_context.md` artifact for the next Cursor turn.

You can reuse the same pattern for any saved contract: `list_contracts` → `get_contract` → `run_contract` → `get_run`.

### Working Demo

Watch the end-to-end Cursor MCP demo: test a workflow API from the IDE, execute the contract, and feed auto-generated AI context back to the agent.

**[Test Workflow APIs with AI Agent Contracts and Auto-Generated AI Context](https://youtu.be/GAt-V7jL4e0?si=lcWUECktH2ZkjOOw)**

In the demo, Cursor:

1. Calls `run_contract` with a SuperContracts YAML workflow.
2. Captures run artifacts — `run.json`, `response.json`, and `ai_context.md`.
3. Uses the generated AI context to explain failures, suggest fixes, and continue debugging — all inside the same chat.

### Example 1

Ask Cursor™ to:

```text
Refund Stripe payment for Order #10482.
```

SuperContracts executes the workflow, requests approval if needed, performs the refund, and records the complete audit trail.

### Example 2

Ask Cursor™ to:

```text
Create a new Supabase table for feature flags.
```

SuperContracts validates the SQL, executes the migration, and records the executed SQL, user, timestamp, and result.

---
## API Workflow Testing & Execution

Centralize API behavior, dependencies, conditions, tests, and workflow steps in a single executable contract.

This eliminates fragmented scripts and helps multi-step workflows run predictably and consistently.

### Example

Execute a Supabase todos CRUD workflow that:

1. Creates a todo (`POST /rest/v1/todos`).
2. Lists todos (`GET /rest/v1/todos`).
3. Gets the created todo by ID (`GET` with `id=eq.{create.response.body.0.id}`).
4. Updates the todo title (`PATCH`).
5. Deletes the todo (`DELETE`, expect `204`).

### Code Samples

Chained flow — create → list → get → update → delete, with the todo ID passed from the create step:

```yaml
flows:
  todos_crud:
    description: "Create → list → get → update → delete with chained todo ID."
    steps:
      - step: create
        action: create_todo
        inputs:
          body:
            title: "E2E Todo"
            user_id: "5cb5b240-8bd4-4172-a219-e7561214697a"

      - step: list
        action: list_todos
        inputs:
          select: "*"

      - step: get
        action: get_todo
        inputs:
          id: "eq.{create.response.body.0.id}"
          select: "*"

      - step: update
        action: update_todo
        inputs:
          id: "eq.{create.response.body.0.id}"
          body:
            title: "Updated E2E"

      - step: delete
        action: delete_todo
        inputs:
          id: "eq.{create.response.body.0.id}"
```

Assertions on status codes and response fields:

```yaml
tests:
  todos_crud:
    description: "Full todos CRUD with models exported to run context."
    execute: todos_crud
    expect:
      create: 201
      list: 200
      get: 200
      update: 200
      delete: 204
    verify:
      - "create.response.body.0.id != null"
      - "update.response.body.0.title == 'Updated E2E'"
```

See the complete recipe (models, routes, auth, and tests) in [supabase_crud.yaml](https://github.com/apilabs-ai/apilabs_api_contract_recipes_pvt/blob/main/supabase_crud.yaml).

---
## Avoid Context Switching - Do more... Stay in Cursor IDE + Super Contracts MCP

---
## MCP Guardrails 

Control how AI models interact with Model Context Protocol tools.

SuperContracts acts as a policy-enforcement layer that blocks unauthorized, unsafe, or unverified tool calls before they reach connected systems.

### Example 1

Permit the GitHub MCP server to create branches and pull requests, but block direct pushes to the `main` branch.

### Example 2

Allow the Supabase MCP server to run `SELECT` queries while blocking `DROP TABLE` and unrestricted `DELETE` operations.

---

## AI Agent Guardrails

Define the systems, tools, data, and actions an AI agent is permitted to access.

These guardrails keep autonomous agents within approved boundaries and prevent unauthorized changes to enterprise systems.

### Example 1

Allow an AI support agent to read Stripe customer and subscription information, but prevent it from issuing refunds.

### Example 2

Allow an AI coding agent to create GitHub branches and pull requests, but prevent it from deploying changes to production.

---

## Production Action Approval

Add human-in-the-loop controls for destructive, sensitive, or high-impact production actions.

Operations such as database migrations, bulk deletions, refunds, or infrastructure changes cannot proceed without explicit authorization.

### Example 1

Require Finance approval before executing Stripe refunds above `$500`.

### Example 2

Require Database Administrator approval before applying a migration to a production Supabase database.

---

## Slack™ Bot Guardrails

Control what Slack™ bots and AI agents can read, post, approve, and execute from conversations.

SuperContracts can restrict sensitive channels, block unauthorized commands, require approval for high-risk actions, validate the requesting user, and retain evidence of every bot-triggered operation.

### Example 1

An authorized finance user submits:

```text
/refund ORD-10482
```

SuperContracts validates the user and starts the Stripe refund workflow.

### Example 2

A user submits:

```text
/deploy production
```

SuperContracts requires Release Manager approval before triggering the GitHub Actions deployment.

---





The goal is to create a neutral, open format for safe API, MCP, and AI-agent execution.

---

## License

Apache-2.0

## Support

Join Discord Channel
https://discord.com/invite/rVC2YMQH4
