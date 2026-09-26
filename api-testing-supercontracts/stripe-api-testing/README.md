# Stripe API Testing

A SuperContracts API-testing suite for Stripe test-mode account validation, customer lifecycle testing, and controlled pass/fail demonstrations.

---

## What the demo proves

The contract reads the Stripe account and exercises a customer create, retrieve, and delete flow. It uses Stripe test mode and includes three expected passes plus two intentional failures.

---

## Repository layout

```text
stripe-api-testing/
├── README.md
└── stripe-api-testing.yml
```

---

## Test coverage

| Test | Expected result | What it checks |
| --- | --- | --- |
| `stripe_account_response_validation` | Pass | Account status, schema, and object type |
| `stripe_account_country_contract` | Intentional fail | Stripe returns a string country while the model expects an integer |
| `stripe_customer_lifecycle` | Pass | Create, retrieve, and delete the same test customer |
| `stripe_customer_email_contract` | Intentional fail | Returned email differs from the expected business value |
| `stripe_missing_customer_behavior` | Pass | Missing-customer status and Stripe error schema |

---

## Authentication

Store a Stripe **test-mode** secret key in the API Labs Auth Vault and replace the placeholder `auth.secret_arn` in `stripe-api-testing.yml`. Never use a live-mode key or commit the secret itself.

---

## Run it

1. Save `stripe-api-testing.yml` in **API Contract Model** on [apilabs.ai](https://apilabs.ai).
2. Use `list_contracts` to locate the saved contract.
3. Use `get_contract` with its `connection_id` and keep the complete returned YAML.
4. Use `run_contract` with the same `connection_id`, returned `contract_yaml`, and one test name from the table above.
5. Use `get_run` with the returned `run_id` to review step results and expected-versus-actual assertions.

The lifecycle tests create disposable test customers and include a cleanup delete step.
