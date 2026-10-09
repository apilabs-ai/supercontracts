# DuckDB SQL analytics

This example runs a read-only DuckDB query over a CSV, JSON, or Parquet file already stored in ApiLabs Explorer.

1. Replace `CHANGE_ME_EXPLORER_FILE_ARN` with the data file ARN from Explorer.
2. Save the YAML as a SuperContract.
3. Run it from the SuperContracts run-flow page or call the MCP `run_sql` tool with the full YAML and the saved contract `connection_id`.

The response contains the columns, rows, returned-row count, truncation flag, and execution time. SQL contracts and their `__run.json`, `__response.json`, and `__ai_context.md` artifacts are organized under `SQL_Analytics/<contract-name>/` in Explorer.

Only one read-only `SELECT`/`WITH` statement is accepted. `max_rows` defaults to 100 and cannot exceed 1,000. Queries may read only the aliases declared under `inputs.files`; the runtime resolves and authorizes their Explorer ARNs.
