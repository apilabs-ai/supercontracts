# SuperContracts Supabase CRUD Demo

A minimal local contract showing how an executable SuperContract can run a chained Todos CRUD workflow against Supabase PostgREST and assert the results.

---

## What the demo proves

The todos API is exercised as one workflow, not isolated requests:

> Create a todo, then list / get / update it using the ID returned from create.

The contract starts from a declared API shape (`models` + `routes`), runs `todos_crud` end to end, and verifies status codes plus response fields — so a coding agent (or you) can see exactly what passed or broke.

---

## Repository layout

```
supabase-crud-local-contracts/
├── README.md
└── supabase-crud-local-contracts.yaml   # api, auth, models, routes, flow, test
```

---

## How the contract is structured

| Section | Role |
| --- | --- |
| `api` / `auth` | Base URL + bearer token via `secret_arn` |
| `models` | Request/response shapes (`Todo`, `TodoCreate`, …) |
| `routes` | `create_todo`, `list_todos`, `get_todo`, `update_todo` |
| `flows` | Ordered steps with ID chaining |
| `tests` | Status expectations + field asserts |

Chaining looks like this:

```yaml
id: "eq.{create.response.body.0.id}"
```

Later steps pull the created todo’s `id` from the create response.

---

## Setup

1. Set `api.base_url` to your Supabase project URL
2. Point `auth.secret_arn` at a user JWT in Auth Vault
3. Set route `apikey` headers to your Supabase key
4. Use a real `user_id` in the create step (and matching `verify` check)

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_contracts` — find this contract
2. `get_contract` — load by `connection_id`
3. `run_contract` — execute `todos_crud`
4. `get_run` — inspect assertions and responses

Pass `connection_id` into `run_contract` so `__run.json`, `__response.json`, and `__ai_context.md` are saved next to the YAML.
