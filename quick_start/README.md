# 🚀 Quick Start

Go from a new installation to a protected AI-agent action.

1. [What are SuperContracts?](./what-are-supercontracts.md)
2. [Connect your AI Agent](./connect-your-ai-agent.md)
3. [Authenticate](./authenticate.md)
4. [Run your first protected action](./run-your-first-protected-action.md)

The first run uses a read-only GitHub contract. Additional read-only examples are included for Gmail and Google Calendar.

## Quick Start contracts

| Provider | Ask your AI agent | Contract | Test name |
| --- | --- | --- | --- |
| GitHub | “List my repositories.” | [`github-read-repositories.yml`](./github-read-repositories.yml) | `github_read_repositories` |
| Gmail | “Show my 5 most recent emails.” | [`gmail-read-emails.yml`](./gmail-read-emails.yml) | `gmail_read_recent_emails` |
| Google Calendar | “Show my upcoming events.” | [`google-calendar-read-events.yml`](./google-calendar-read-events.yml) | `google_calendar_read_upcoming_events` |

For client-specific configuration, see:

- [Cursor](../ai_clients/cursor.md)
- [Claude Code](../ai_clients/claude-code.md)
- [Codex](../ai_clients/codex.md)
- [VS Code / GitHub Copilot](../ai_clients/vscode-github-copilot.md)

[Back to SuperContracts](../README.md)
