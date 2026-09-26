# Supabase API Testing

A controlled SuperContracts API-testing suite for Supabase PostgREST customer reads, lifecycle operations, schema checks, regression checks, headers, and latency assertions.

---

## What the demo proves

The contract contains five expected passes and five intentional failures. It covers response status, chained IDs, model validation, grouped regression checks, JSON response headers, and request-duration limits against a disposable `sc_customers` table.

---

## Repository layout

```text
supabase-api-testing/
├── README.md
└── supabase-api-testing.yml
```

---

## Test coverage

| Test | Expected result | What it checks |
| --- | --- | --- |
| `customer_response_status_pass` | Pass | Fixture response, status, JSON values, and plan |
| `customer_response_status_fail` | Intentional fail | Supabase returns `200` while the test expects `201` |
| `customer_lifecycle_pass` | Pass | Create, extract ID, retrieve, and delete |
| `customer_chained_value_fail` | Intentional fail | Retrieved ID differs from a deliberately incorrect value |
| `invalid_customer_behavior_pass` | Pass | Invalid UUID returns JSON `400` within the latency limit |
| `customer_schema_validation_pass` | Pass | UUID, email, enum, boolean, and datetime constraints |
| `customer_id_type_contract_fail` | Intentional fail | UUID string is checked against an integer model |
| `customer_regression_checks_pass` | Pass | Grouped fixture and customer regression checks |
| `customer_regression_value_fail` | Intentional fail | Actual plan differs from the deliberately expected value |
| `invalid_customer_latency_fail` | Intentional fail | Correct `400` response exceeds an unrealistic 1 ms limit |

---

## Setup and authentication

1. Use a disposable Supabase project and create the `sc_customers` table and fixture expected by the contract.
2. Update `api.base_url` for that project.
3. Store its anon credential securely and configure the contract authentication for that credential. Do not commit a real credential.
4. Keep Row Level Security policies limited to the demo operations and data.

---

## Run it

1. Save `supabase-api-testing.yml` in **API Contract Model** on [apilabs.ai](https://apilabs.ai).
2. Use `list_contracts` to locate the saved contract.
3. Use `get_contract` with its `connection_id` and keep the complete returned YAML.
4. Use `run_contract` with the same `connection_id`, returned `contract_yaml`, and one test name from the table above.
5. Use `get_run` with the returned `run_id` to review step results and expected-versus-actual assertions.

Run intentional failures separately when capturing predictable failure evidence. The lifecycle flow deletes the row it creates.
