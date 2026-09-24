# GitHub API Testing

A SuperContracts API-testing suite for authenticated GitHub REST API reads, response-schema validation, and clear pass/fail demonstrations.

---

## What the demo proves

The contract validates an authenticated GitHub user, repository listings, rate-limit data, and missing-repository behavior. It includes two expected passes and three intentional failures so recorded evidence shows both successful checks and useful diagnostics.

---

## Repository layout

```text
github-api-testing/
├── README.md
└── github-api-testing.yml
```

---

## Test coverage

| Test | Expected result | What it checks |
| --- | --- | --- |
| `github_user_response_validation` | Pass | Authenticated-user status, schema, and user type |
| `github_user_id_contract` | Intentional fail | GitHub returns a numeric ID while the model expects a string |
| `github_read_api_regression` | Pass | User, repository-list, and rate-limit responses |
| `github_repository_status_contract` | Intentional fail | Repository listing returns `200` while the test expects `201` |
| `github_missing_repository_behavior` | Intentional fail | Missing repository returns `404` while the test expects `400` |

---

## Authentication

Store a GitHub token in the API Labs Auth Vault and replace the placeholder `auth.secret_arn` in `github-api-testing.yml`. The token needs read access to the authenticated user and their repositories. Never commit the token itself.

---

## Run it

1. Save `github-api-testing.yml` in **API Contract Model** on [apilabs.ai](https://apilabs.ai).
2. Use `list_contracts` to locate the saved contract.
3. Use `get_contract` with its `connection_id` and keep the complete returned YAML.
4. Use `run_contract` with the same `connection_id`, returned `contract_yaml`, and one test name from the table above.
5. Use `get_run` with the returned `run_id` to review step results and expected-versus-actual assertions.

Run intentional failures separately when you want predictable failure evidence.
