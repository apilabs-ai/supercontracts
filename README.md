# Open Contract Spec

**An open executable contract format for APIs, MCP tools, AI agents, workflows, approvals, tests, and guardrails.**

Open Contract Spec defines how software systems should be called, tested, secured, approved, and executed — in a format humans, tools, and AI agents can understand.

Traditional API specs describe endpoints.

**Open Contract Spec describes execution, policy, and safety.**

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

## Use Cases & Code Recipes

### 1. API Workflow Testing

Define API behavior and expected results in the same contract.

```yaml
contract:
  name: user-api-test
  version: 0.1.0

action:
  name: get_user
  method: GET
  path: /users/{user_id}

test:
  name: get_user_returns_200
  input:
    user_id: "123"
  expect:
    status: 200
    response:
      id: "123"
```

---

### 2. Production Action Approval

Require human approval before high-risk production actions.

```yaml
contract:
  name: stripe-refund
  version: 0.1.0

action:
  name: refund_order
  method: POST
  path: /v1/refunds

guardrails:
  - rule: amount <= 100
    action: allow

  - rule: amount > 100
    action: require_approval
    approver: finance

evidence:
  retain:
    - request
    - response
    - approval_id
    - actor
    - timestamp
```

---

### 3. MCP Tool Safety

Control what MCP tools can and cannot do.

```yaml
contract:
  name: github-mcp-guardrails
  version: 0.1.0

mcp:
  server: github

tools:
  create_pull_request:
    allowed: true

  push_to_main:
    allowed: false

  merge_pull_request:
    requires_approval: true
    approver: engineering-lead
```

---

### 4. AI Agent Guardrails

Give agents clear permissions before they touch real systems.

```yaml
contract:
  name: support-agent-policy
  version: 0.1.0

agent:
  name: support_agent

permissions:
  allow:
    - read_orders
    - draft_refund
    - request_approval

  deny:
    - delete_customer
    - issue_refund_without_policy
    - send_sensitive_email_without_approval
```

---

### 5. Workflow Execution

Define multi-step workflows with dependencies.

```yaml
contract:
  name: refund-workflow
  version: 0.1.0

workflow:
  name: customer_refund_flow

  steps:
    - id: lookup_order
      action: orders.get

    - id: check_policy
      action: policy.evaluate
      depends_on:
        - lookup_order

    - id: request_approval
      action: approvals.create
      when: refund.amount > 100
      depends_on:
        - check_policy

    - id: issue_refund
      action: stripe.refund
      depends_on:
        - check_policy
        - request_approval
```

---

### 6. Runtime Evidence

Capture what happened during execution.

```yaml
contract:
  name: evidence-capture
  version: 0.1.0

evidence:
  retain:
    - actor
    - action
    - input
    - policy_result
    - approval_id
    - request
    - response
    - timestamp
    - trace_id
```

---

## Implementation

Open Contract Spec is being implemented in **SuperContracts from [apilabs.ai](https://apilabs.ai)**.

SuperContracts turns open contracts into executable API, MCP, and AI-agent workflows with runtime guardrails, approvals, testing, and evidence capture. Further, SuperContracts is deeply integrated via MCP in AI IDE tools like Cursor.

---

## Status

Open Contract Spec is in early public development.

The goal is to create a neutral, open format for safe API, MCP, and AI-agent execution.

---

## Website
Developer website with code recipes, playground and demos 
[supercontracts.dev](https://supercontracts.dev)

---

## License

Apache-2.0
