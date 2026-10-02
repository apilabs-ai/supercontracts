# Run your first protected action

Start with a read-only contract. Each example makes one safe provider request and verifies that the provider returns HTTP `200`.

| Provider | Ask your AI agent | Contract | Test name |
| --- | --- | --- | --- |
| GitHub | “List my repositories.” | [`github-read-repositories.yml`](./github-read-repositories.yml) | `github_read_repositories` |
| Gmail | “Show my 5 most recent emails.” | [`gmail-read-emails.yml`](./gmail-read-emails.yml) | `gmail_read_recent_emails` |
| Google Calendar | “Show my upcoming events.” | [`google-calendar-read-events.yml`](./google-calendar-read-events.yml) | `google_calendar_read_upcoming_events` |

Use the GitHub example for the first demo because it has no date input and returns a short, recognizable result.

**[Watch the complete Cursor Quick Start video](https://drive.google.com/file/d/1zqJGDPoM3w9FN-yXL2a4E6o6apey8kgU/view?usp=sharing)**

The video shows the SuperContracts MCP connection, contract discovery, `get_contract`, and a successful `run_contract` execution of the GitHub example.

## 1. Confirm the MCP connection

Open Cursor's MCP settings and confirm that the `supercontracts` server shows **Connected**.

<p align="center">
  <img src="../images/quick_start/quick_start_01_mcp_connected.png" alt="Cursor showing the SuperContracts MCP server connected in the local environment" width="560">
</p>

Open the server configuration and verify that its tools include `list_contracts`, `get_contract`, `run_contract`, and `get_run`. A connected status without a populated tool list is not sufficient verification.

<p align="center">
  <img src="../images/quick_start/quick_start_02_mcp_connected.png" alt="Cursor showing the tools exposed by the SuperContracts MCP server" width="500">
</p>

## 2. Load the saved contract

Ask Cursor:

```text
Use SuperContracts to find the saved quick-start contract for reading GitHub repositories.
Call get_contract and show me its test names. Do not run it yet.
```

Cursor should use `list_contracts`, then `get_contract`, and return the test name `github_read_repositories`.

## 3. Run the contract

Ask Cursor:

```text
Run the github_read_repositories test from the contract you just loaded.
Use the complete contract_yaml returned by get_contract and the same connection_id.
Show the expected-versus-actual assertion and the repositories returned.
```

Cursor should call `run_contract` with:

- the complete `contract_yaml` returned by `get_contract`
- the same `connection_id`
- test `github_read_repositories`

Expected result:

```text
Step: repositories
Expected status: 200
Actual status: 200
Result: PASS
```

The response contains up to 10 repositories, sorted by most recently updated.

## 4. Inspect the evidence

Ask Cursor:

```text
Use get_run with the returned run_id and summarize the saved evidence.
```

The run should contain the request, response, status assertion, step result, and run metadata.

For saved contracts, always follow:

```text
list_contracts → get_contract → run_contract → get_run
```

Do not reconstruct or shorten the YAML after `get_contract`. Pass its complete `contract_yaml` and the same `connection_id` to `run_contract` so the execution and artifacts remain associated with the saved contract.

> Before publishing a screenshot or recording, mask MCP tokens, provider Secret ARNs, connection IDs, private repository names, and other account-specific data.

[Back to Quick Start](./README.md)
