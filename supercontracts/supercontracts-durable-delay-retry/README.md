# Wait for a write, then check the result

This SuperContract creates a Supabase todo, reads it back, updates it, reads it
again, and deletes it. The two reads demonstrate `wait_before` and
`retry_until`.

Some APIs accept a create or update request before the new data is visible to a
later read. A successful write response tells you the request succeeded; it
does not always tell you when every read will show the change. This example
lets the contract writer say when to wait and what result to look for.

## What the timing settings do

| Setting | What it does here | When it helps |
| --- | --- | --- |
| `wait_before: 15s` | Waits 15 seconds **before** each `get_todo` request. It runs once for that step. | You know the API usually needs a short settling period after a write. |
| `retry_until.verify` | Checks the GET response for the created ID or updated title. | HTTP 200 alone can still contain an empty list or old data. |
| `retry_until.attempts: 5` | Allows up to five GET checks, **including the first**. It stops as soon as the check passes. | The data may become visible sooner than the maximum wait. |
| `retry_until.delay: 3s` | Waits three seconds between unsuccessful checks. | Avoids repeatedly calling the API without a pause. |
| `retry_until.timeout: 30s` | Caps the retry period for that step at 30 seconds. | Keeps a stale result from waiting indefinitely. |

For example, after `create_todo`, the contract waits 15 seconds and calls
`get_todo`. If the GET returns HTTP 200 with an empty list, the `verify`
condition fails, so it waits three seconds and checks again. If the expected
todo appears on the second check, it continues immediately; it does not make
the remaining three calls. The same pattern checks that the updated title is
visible after `update_todo`.

The `wait_before` setting works on any sequential HTTP step. `retry_until`
works on GET, HEAD, or OPTIONS steps and needs a condition that describes the
result you expect. A response model by itself cannot tell whether a newly
written row is visible. If an API temporarily returns 404 before a new row
appears, add `retry_statuses: [404]` to that step's `retry_until` block.
Only list statuses that your API can legitimately return while the result is
still pending. This todo example uses Supabase's HTTP 200 with an empty list,
so it does not need `retry_statuses`.

## What the contract runs

```text
POST create → wait 15s → GET until created ID is visible
            → PATCH update → wait 15s → GET until updated title is visible
            → DELETE the created todo
```

Both GET steps use the ID returned by the POST, so they inspect the same todo.
The DELETE step runs after the checks pass. If an earlier step fails, the flow
stops and the created row may need manual cleanup.

## Set up your own test

1. Use a disposable Supabase project with a `public.todos` table containing
   `id` (UUID), `user_id` (UUID), `title`, `description`, and `created_at`.
   The `id` should be generated when a row is inserted. Configure Row Level
   Security so an authenticated user can create, read, update, and delete only
   their own todos.
2. Create a test user and sign in to get that user's **access token**. Store
   the token in ApiLabs Auth Vault as a bearer credential. Copy its Secret ARN.
   The access token expires, so refresh it in Auth Vault before another test
   if Supabase returns `401 JWT expired`.
3. Copy `supercontracts-durable-delay-retry.yml` and replace these values:

   | Placeholder | Replace with |
   | --- | --- |
   | `YOUR_PROJECT_REF` | Your Supabase project reference in `api.base_url` |
   | `YOUR_SUPABASE_USER_TOKEN_SECRET_ID` | The ID from the Auth Vault Secret ARN for the user's access token |
   | `YOUR_SUPABASE_PUBLISHABLE_KEY` | Your project's publishable API key in each route's `apikey` header |
   | `YOUR_AUTH_USER_ID` | The signed-in test user's UUID; it must match the bearer token's user |

The `apikey` header identifies the Supabase project; the bearer token
identifies the user. Both are needed for this example's authenticated, owner
restricted table. Do not put a real token or key in a public Git commit.

## Run and inspect it

Save the edited YAML in ApiLabs **Supercontracts → run_contract**, then run the
`todos_timed_visibility` test. Because the flow contains waits, the run may
first show **queued**. Open **Results** to watch it finish and inspect each
step. A successful run has five passing steps: create, get created, update,
get updated, and delete.

With the SuperContracts MCP tool, call `run_contract` with the complete edited
YAML and `run: "todos_timed_visibility"`. If it returns a `run_id` with
`queued` or `running`, call `get_run` with that ID until the run reaches a final
state. For a contract already saved in Explorer, pass its `connection_id` too
so the run artifacts are saved beside it.

The sample uses two fixed 15-second waits, so a complete run normally takes
more than 30 seconds. Background execution lets the run continue after the
initial HTTP response. A failed or interrupted write is not automatically
replayed: check Supabase before manually running the contract again, since a
previous write may already have succeeded.

See the [contract YAML](./supercontracts-durable-delay-retry.yml) for the exact
`wait_before` and `retry_until` blocks.
