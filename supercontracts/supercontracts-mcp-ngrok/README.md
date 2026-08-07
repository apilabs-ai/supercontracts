# SuperContracts Ngrok Cursor Demo

A minimal local contract showing how an executable SuperContract can hit a **local backend through an ngrok (or Cloudflare) tunnel**, then create and publish a seller property end to end.

---

## What the demo proves

The seller property API is exercised as one workflow against a tunnel URL, not isolated requests:

> Auth me → create draft property → list → get by ID → publish → list public.

The contract starts from a declared API shape (`models` + `routes`), runs `milkat_property_demo` end to end, and verifies status codes plus response fields — so a coding agent (or you) can see exactly what passed or broke.

---

## Repository layout

```
supercontracts-mcp-ngrok/
├── README.md
└── ngrok_cursor_demo.yaml   # api, auth, models, routes, flow, test
```

---

## How the contract is structured

| Section | Role |
| --- | --- |
| `api` / `auth` | Tunnel `base_url` + bearer token via `secret_arn` |
| `models` | Request/response shapes (`PropertyCreate`, `PublishResponse`, …) |
| `routes` | `me`, `create_seller_property`, `list_seller_properties`, `get_property`, `publish_property`, … |
| `flows` | Ordered steps with ID chaining |
| `tests` | Status expectations + field asserts |

Chaining looks like this:

```yaml
id: "{create.response.body.data.id}"
```

Later steps pull the created property’s `id` from the create response.

---

## Cloudflare / Ngrok (local access)

Your backend runs on localhost. SuperContracts (and remote runners) need a public URL to reach it.

1. Start the local API
2. Expose it with **Ngrok** or **Cloudflare Tunnel**
3. Copy the public HTTPS URL into `api.base_url`

Example:

```yaml
api:
  base_url: "https://<your-subdomain>.ngrok-free.dev"
```

Update `base_url` whenever the tunnel URL changes (common on free ngrok tiers).

---

## Secret ARN

`secret_arn` is a reference to a credential stored in **Auth Vault** on [apilabs.ai](https://apilabs.ai) — not the token itself.

Example:

```yaml
auth:
  type: bearer
  in: header
  secret_arn: "arn:apilabs:secret:<your-vault-secret-id>"
```

At run time, SuperContracts resolves the ARN and injects the bearer token. The real JWT stays in the vault, so you can share the YAML without leaking secrets.

---

## API authentication

Two ways to authenticate API calls:

### 1. Auth Vault + Secret ARN (recommended)

1. Log in to [apilabs.ai](https://apilabs.ai)
2. Open **Auth Vault** and store your seller/user JWT (or API token)
3. Copy the generated **Secret ARN**
4. Paste it into `auth.secret_arn` in the contract

### 2. Add tokens directly

Put the bearer token straight into the contract YAML headers / auth fields.

Works for quick local runs, but avoid committing real tokens to git.

---

## Setup

1. Start the local backend and expose it via Ngrok or Cloudflare Tunnel
2. Set `api.base_url` to that public tunnel URL
3. Configure auth (Secret ARN recommended, or tokens directly — see above)
4. Confirm create/publish payloads match your API (title, city, listing type, etc.)

---

## Run it

With SuperContracts MCP connected in Cursor:

1. `list_contracts` — find this contract
2. `get_contract` — load by `connection_id`
3. `run_contract` — execute `milkat_property_demo`
4. `get_run` — inspect assertions and responses

Pass `connection_id` into `run_contract` so `__run.json`, `__response.json`, and `__ai_context.md` are saved next to the YAML.
