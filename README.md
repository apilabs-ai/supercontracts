# apilabs.ai Super Contracts

> **One executable contract for APIs, MCPs, workflows, and AI agents.**
>
> Define once. Generate documentation, tests, workflows, MCP tools, agent actions, observability, and runbooks from a single contract.

🌐 **Website:** https://apilabs.ai

📖 **DSL Specification:** https://apilabs.ai/help/api-dsl-spec-draft

📄 **Research Paper:** https://apilabs.ai/research/executable-api-contracts

🎥 **Introduction Video:** https://youtu.be/GAt-V7jL4e0

▶️ **Video Tutorials & Examples:** https://www.youtube.com/playlist?list=PLcyYgx7v_H5Ifsss1nQrzBlrzZdlnb_k4

![License](https://img.shields.io/badge/license-Apache%202.0-blue)
![Status](https://img.shields.io/badge/status-active-green)
![Spec](https://img.shields.io/badge/spec-v1-orange)

---

# Super Contracts are Infrastructure as Code for APIs

**Super Contracts are to APIs, MCPs, workflows, and AI agents what Infrastructure as Code is to cloud infrastructure.**

A single executable source of truth for:

- API Documentation
- API Testing
- Workflow Automation
- MCP Tool Generation
- AI Agent Actions
- Observability
- Runbooks
- Mock APIs
- Runtime Context

---

# Why Super Contracts?

Modern API, workflow, and AI teams often maintain multiple disconnected artifacts:

- OpenAPI Specifications
- Swagger Documentation
- Postman Collections
- API Test Suites
- Workflow Definitions
- MCP Tool Definitions
- Agent Actions
- Runbooks
- Monitoring Configurations
- Operational Documentation

These artifacts inevitably drift from one another.

Super Contracts unify design, testing, execution, automation, and operations into a single executable contract.

---

# Getting Started

## DSL Specification

Draft specification for the Super Contract DSL:

👉 https://apilabs.ai/help/api-dsl-spec-draft

## Research Paper

Technical foundation behind executable API contracts:

👉 https://apilabs.ai/research/executable-api-contracts

## Introduction Video

Quick walkthrough:

👉 https://youtu.be/GAt-V7jL4e0

## Video Tutorials & Examples

Implementation guides and demonstrations:

👉 https://www.youtube.com/playlist?list=PLcyYgx7v_H5Ifsss1nQrzBlrzZdlnb_k4

---

# Code Samples (Coming Soon)

Code samples, SDKs, examples, and reference implementations are currently being prepared and will be released to the developer community soon.

Planned examples include:

- REST APIs
- GraphQL APIs
- MCP Servers
- AI Agent Actions
- Workflow Automation
- OpenAPI Migration
- Contract Testing
- Private API Connectivity
- CI/CD Integration

---

# One Contract → Many Outputs

```text
                    Super Contract
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼

 Documentation      Test Automation     Workflows

        ▼                  ▼                  ▼

    MCP Tools       Agent Actions     Observability

                           ▼

                    Runtime Execution
```

| Output | Generated From Contract |
|----------|-----------|
| API Documentation | ✅ |
| OpenAPI / Swagger | ✅ |
| API Tests | ✅ |
| Workflows | ✅ |
| MCP Tools | ✅ |
| AI Agent Actions | ✅ |
| Mock APIs | ✅ |
| CI/CD Pipelines | ✅ |
| Runbooks | ✅ |
| Observability | ✅ |
| Runtime Context | ✅ |

---

# What Makes Super Contracts Different?

Unlike traditional API specifications, Super Contracts can model:

- APIs
- Authentication
- Workflows
- Tests
- MCP Tools
- Agent Actions
- Tokens
- Files
- Runtime Context
- Operational Policies

within a single executable specification.

Most API specifications stop at describing endpoints.

Super Contracts describe the resources, workflows, tests, and execution semantics required to operate them.

---

# Example Contract

```yaml
contract:
  format: apilabs.ai
  version: "1.0"

auth:
  type: bearer
  token_arn: arn:apilabs:token:supabase

routes:

  getTodo:
    method: GET
    path: /todos/{id}

tests:

  - name: Verify Todo

    route: getTodo

    expect:
      status: 200
```

See the DSL specification for complete examples and advanced workflows.

---

# Tokens and Files as ARNs

Super Contracts support referencing credentials, files, and runtime assets through **ARNs (Asset Resource Names)**.

Instead of embedding secrets and files directly into contracts, resources are referenced through stable identifiers.

This keeps contracts:

- Secure
- Portable
- Reusable
- Environment Independent
- AI Friendly

---

## Token ARNs

Instead of:

```yaml
auth:
  token: "secret-token"
```

Use:

```yaml
auth:
  token_arn: arn:apilabs:token:stripe-prod
```

Examples:

```text
arn:apilabs:token:github-prod
arn:apilabs:token:stripe-prod
arn:apilabs:token:openai-prod
arn:apilabs:token:salesforce-dev
```

---

## File ARNs

Files uploaded to apilabs.ai can also be referenced using ARNs.

```yaml
body_file_arn: arn:apilabs:file:invoice-request.json
```

Examples:

```text
arn:apilabs:file:customers.csv
arn:apilabs:file:test-orders.json
arn:apilabs:file:invoice.pdf
arn:apilabs:file:agent-prompt.md
```

Supported file types:

- CSV
- JSON
- XML
- YAML
- PDF
- Images
- Prompt Templates
- Configuration Files

---

## Workflow Example

```yaml
workflow:

  create_invoice:

    route: createInvoice

    auth:
      token_arn: arn:apilabs:token:stripe-prod

    body_file_arn: arn:apilabs:file:invoice-request.json
```

Execution flow:

1. Resolve Token ARN
2. Resolve File ARN
3. Execute API
4. Capture Outputs
5. Generate Runtime Context

---

## Future ARN Types

```text
arn:apilabs:token:github-prod
arn:apilabs:file:customers.csv

arn:apilabs:workflow:order-processing
arn:apilabs:contract:user-service
arn:apilabs:agent:customer-support
arn:apilabs:model:gpt-5
arn:apilabs:dataset:customer-analytics
```

---

# Core Concepts

## APIs

Define routes, authentication, schemas, requests, responses, and validation rules.

## Workflows

Model stateful business processes, dependencies, retries, branching, and orchestration.

## Tests

Generate automated contract tests, regression tests, and validation suites.

## MCP Tools

Generate MCP-compatible tools for Cursor, Windsurf, VS Code, Claude Code, and other AI runtimes.

## Agent Actions

Define permissions, execution constraints, policies, and agent behavior.

## Observability

Generate traces, metrics, logs, runtime context, and operational visibility.

---

# Why Not OpenAPI?

OpenAPI describes APIs.

Super Contracts describe:

- APIs
- Authentication
- Tests
- Workflows
- MCP Tools
- Agent Actions
- Runtime Assets
- Observability
- Execution Policies

OpenAPI is documentation-first.

Super Contracts are execution-first.

---

# Compatibility

## Import

- OpenAPI
- Swagger
- Postman Collections

## Generate

- OpenAPI
- Swagger Documentation
- Postman Collections
- MCP Tools
- Agent Actions
- Test Suites
- Runbooks
- Observability Assets

---

# Super Contracts vs Traditional Approaches

| Capability | OpenAPI | Postman | MCP | Super Contracts |
|------------|----------|----------|------|----------------|
| API Schema | ✅ | Partial | ❌ | ✅ |
| Authentication | Partial | Partial | ❌ | ✅ |
| Testing | ❌ | ✅ | ❌ | ✅ |
| Stateful Workflows | ❌ | Partial | ❌ | ✅ |
| Agent Actions | ❌ | ❌ | Partial | ✅ |
| Runtime Context | ❌ | ❌ | ❌ | ✅ |
| Observability | ❌ | ❌ | ❌ | ✅ |
| Executable Contract | ❌ | Partial | ❌ | ✅ |
| Token Resources | ❌ | ❌ | ❌ | ✅ |
| File Resources | ❌ | ❌ | ❌ | ✅ |

---

# Use Cases

## API Contract Testing

Generate and execute tests directly from contracts.

## Workflow Automation

Execute multi-step business processes through stateful workflows.

## MCP Tool Generation

Generate tools for AI IDEs and MCP-compatible runtimes.

## AI Agents

Provide structured actions, permissions, execution policies, and runtime context.

## Private APIs

Securely connect to localhost, VPN, and internal enterprise APIs.

## API Operations

Generate monitoring, observability, runbooks, and operational workflows.

---

# Roadmap

## Current

- API Contracts
- Stateful Workflows
- Test Automation
- MCP Tool Generation
- Runtime Context Generation
- Operational Policies
- Token ARNs
- File ARNs

## Planned

- OpenAPI Import
- Postman Import
- Visual Contract Designer
- Agent Security Model
- Multi-Agent Orchestration
- Enterprise Governance
- Contract Registry
- Workflow Registry
- Agent Registry

---

# Contributing

Contributions, feedback, feature requests, and design discussions are welcome.

Please open an issue before submitting major changes.

---

# License

Apache License 2.0

---

# Vision

The software industry standardized infrastructure through Infrastructure as Code.

The next step is standardizing API execution, workflows, MCP tools, and AI agents through executable contracts.

Super Contracts provide a single source of truth for:

- Design
- Testing
- Execution
- Automation
- Observability
- Operations

across APIs, MCPs, workflows, and AI agents.

---

**apilabs Super Contracts™**

*The executable contract layer for APIs, MCPs, workflows, and AI agents.*
