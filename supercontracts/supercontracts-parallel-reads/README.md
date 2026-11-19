# Parallel contract reads

This example runs two independent GitHub reads at the same time: the signed-in
user's repositories and notifications. It demonstrates `parallel_group`.

## Rules

Every member of a group must have the same `parallel_group` value and be
adjacent in the flow. A group contains two to four independent GET, HEAD, or
OPTIONS steps. A group member cannot depend on another member and cannot use
timing, loops, deduplication, upserts, or `run_sql`.

The engine records outcomes in YAML order even though the requests start
together. The next step begins only after every member finishes. If one member
fails, other requests in the group may already have started; their evidence is
still recorded and later steps are skipped.

## Run it

1. Store a GitHub token with permission to read repositories and notifications
   in ApiLabs Auth Vault.
2. Replace `YOUR_GITHUB_TOKEN_SECRET_ID` in
   `supercontracts-parallel-reads.yml` with that Auth Vault secret ID.
3. Save the YAML and run `inspect_account`, or call MCP `run_contract` with
   the YAML and `run: "inspect_account"`.

Use parallel groups only for independent reads. Do not use them to parallelize
writes or steps whose inputs depend on one another.
