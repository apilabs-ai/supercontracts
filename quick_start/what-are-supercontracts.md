# What are SuperContracts?

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

SuperContracts can retain the request, policy decision, step results, assertions, response data, approval state, and optional AI context. This makes an agent action reviewable after execution instead of leaving only a chat transcript.

Next: [Connect your AI Agent](./connect-your-ai-agent.md)

[Back to Quick Start](./README.md)
