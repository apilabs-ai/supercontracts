# Skill Register GitHub Demo

A minimal Skill Register policy showing how an agent can push to feature branches, open pull requests, and modify files through GitHub MCP — while blocking force pushes and writes to `main` / `master`.

---

## What the demo proves

GitHub is exercised as a guarded skill, not a raw MCP tool:

> Push and edit on feature branches, open PRs — allowed. Force push or touch `main` / `master` — blocked.

The YAML contains the GitHub Copilot MCP endpoint, inline bearer auth, intent mappings, guardrails, and a default deny. GitHub tools live on `https://api.githubcopilot.com/mcp/`. `run_skill` evaluates the policy first, then calls the mapped MCP tool, so a coding agent (or you) can see exactly what was allowed or blocked.

---

## Repository layout

```
github-skill/
├── README.md
└── github-skill.yaml   # version, domain, intents, guardrails, default
```

---

## How the skill is structured

| Section | Role |
| --- | --- |
| `domain` | Skill domain (`github.com`) |
| `mcp_endpoint` | GitHub Copilot MCP base endpoint |
| `auth` | Bearer auth sent in the header |
| `intents` | Chat/guardrail action -> GitHub MCP tool + operation id |
| `guardrails` | Ordered ALLOW / BLOCK rules |
| `default` | BLOCK anything that does not match a rule |

Intent mapping looks like this:

```yaml
create_pull_request:
  tool: github_api_write
  args:
    github_api_operation_id: CreatePullRequest
```

`run_skill` takes the intent name as `action` (`create_pull_request`), not the upstream tool name (`github_api_write`).

| Intent | MCP tool | GitHub operation | Policy |
| --- | --- | --- | --- |
| `git_push` | `github_api_write` | `GitPush` | ALLOW if feature branch and not force; else default BLOCK |
| `create_pull_request` | `github_api_write` | `CreatePullRequest` | Always ALLOW |
| `modify_file` | `github_api_write` | `ModifyFile` | ALLOW on feature branches; else default BLOCK |

Anything else hits `default: BLOCK`.

---

## Authentication

This example authenticates directly in the YAML with a bearer token:

```yaml
auth:
  type: bearer
  in: header
  secret: <your-github-pat>
```

That matches the current `github-skill.yaml`: requests to GitHub MCP use bearer auth in the request header.

Do not commit real production secrets into git. For shared or long-lived setups, replace the inline secret with your safer secret-management approach before publishing the skill.

---

## Setup

1. Register this skill in **Skill Register** on [apilabs.ai](https://apilabs.ai) with a name such as `github-skill`
2. Paste `github-skill.yaml` as the skill YAML
3. Confirm the file includes:
   - `mcp_endpoint: https://api.githubcopilot.com/mcp/`
   - bearer `auth` with a GitHub PAT
   - intents `git_push`, `create_pull_request`, and `modify_file`
   - guardrails for feature-branch pushes, PRs, and file edits
4. Enable the skill

Without a valid `mcp_endpoint` and auth, the skill is discoverable but not executable.

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_skills` — find this skill
2. `get_skill` — load the saved YAML and confirm `mcp_endpoint`, `auth`, and intents
3. `list_skill_tools` — confirm intents `git_push`, `create_pull_request`, and `modify_file`
4. `run_skill` — execute an intent (`mode: validate` checks policy only)

Examples:

- Allowed push: `skill: github-skill`, `action: git_push`, `args.branch: feature/demo`, `args.force: false`
- Blocked push: `action: git_push`, `args.branch: main` (or `force: true`)
- Allowed PR: `action: create_pull_request`
- Allowed edit: `action: modify_file`, `args.branch: feature/demo`
- Blocked edit: `action: modify_file`, `args.branch: master`

Pass the **intent name** as `action`. Guardrails run first; GitHub MCP is called only on ALLOW.
