# GitHub Slack Approval Demo

A SuperContracts skill that allows GitHub pull-request reads and routes merges to Slack for maintainer approval.

---

## What the demo proves

GitHub is exercised as a guarded skill, not as a raw MCP tool:

> List and read pull requests immediately; merge only after Slack approval tied to the approved commit SHA.

The policy blocks invalid pull-request numbers and merge requests without `expectedHeadSha`. A valid merge returns `APPROVAL_REQUIRED`; it is not executed until the Slack approval is completed and the original request is resumed.

---

## Repository layout

```text
github-slack-approval/
├── README.md
└── github-slack-approval.yaml
```

---

## How the skill is structured

| Section | Role |
| --- | --- |
| `domain` | Skill domain (`github.com`) |
| `mcp_endpoint` | GitHub Copilot MCP endpoint |
| `auth` | Bearer credential referenced from the Auth Vault |
| `intents` | Guarded action to GitHub MCP tool mapping |
| `guardrails` | Ordered ALLOW, BLOCK, and APPROVAL_REQUIRED rules |
| `default` | BLOCK anything that does not match a rule |

| Intent | GitHub MCP tool | Policy |
| --- | --- | --- |
| `list_pull_requests` | `list_pull_requests` | ALLOW when `owner` and `repo` are provided |
| `read_pull_request` | `pull_request_read` | ALLOW |
| `merge_pull_request` | `merge_pull_request` | BLOCK invalid or unbound requests; otherwise require Slack approval |

`run_skill` takes the intent name as `action`, not the upstream MCP tool name.

---

## Authentication

The YAML refers to a bearer credential stored in the apilabs Auth Vault:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: arn:apilabs:secret
```

Replace the placeholder ARN with the ARN for your GitHub credential. Do not commit the underlying token.

---

## Setup

1. Configure the Slack approval provider for your workspace.
2. Register the skill in **Skill Register** on [apilabs.ai](https://apilabs.ai) with a name such as `github-slack-approval`.
3. Paste `github-slack-approval.yaml` as the skill YAML and replace the placeholder `secret_arn`.
4. Confirm the `list_pull_requests`, `read_pull_request`, and `merge_pull_request` intents are available, then enable the skill.

---

## Run it

With SuperContracts MCP connected:

1. Use `list_skills` and select `github-slack-approval`.
2. Use `get_skill` and `list_skill_tools` to inspect the saved policy and intents.
3. Call `run_skill` with an intent name. Use `mode: validate` to check the policy without executing.
4. For a merge, wait for the Slack decision and resume the same pending request after approval.

Examples:

- List PRs: `action: list_pull_requests`, with `owner` and `repo`
- Read a PR: `action: read_pull_request`, with the repository and pull-request number
- Request a merge: `action: merge_pull_request`, with `owner`, `repo`, `pullNumber`, and `expectedHeadSha`

The commit SHA binds the approval to the exact revision reviewed by the maintainer.
