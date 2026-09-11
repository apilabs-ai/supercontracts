# SuperContracts Expression Grammar

**Version 0.10 · Status: Draft · Updated 2026-09-09**

Normative companion to [`supercontracts-spec.yaml`](./supercontracts-spec.yaml). Licensed
Apache-2.0 with the rest of this repository.

This document defines the two expression languages used in SuperContracts contracts: the
**reference language** (step chaining) and the **predicate language** (`verify` assertions), plus
the separate **guardrail condition language** used by `guarded-service` and `skill` contracts.

Every production below is grounded in expressions that appear in shipping contracts. Where the
corpus is silent, the rule is marked **PROPOSED** and requires confirmation against engine behavior
rather than a reader's assumption.

> **Why this document exists.** The runtime already implements this behavior; it had never been
> written down. Until it is, no third party can implement the format — and "a neutral, open format"
> is not a claim the project can support without it.

---

## 1. Reference language (step chaining)

### 1.1 Syntax

```ebnf
reference       = bare-reference | interpolation ;
bare-reference  = path ;                      (* whole value, no braces *)
interpolation   = { text } "{" path "}" { text | "{" path "}" } ;
path            = binding "." "response" "." "body" { "." segment } ;
binding         = identifier ;
segment         = identifier | index ;
identifier      = ( ALPHA | DIGIT | "_" ) { ALPHA | DIGIT | "_" | "-" } ;
index           = DIGIT { DIGIT } ;
```

The two forms differ in result type, not in path syntax — see §1.4, which is the part most likely
to surprise.

`binding` names either a `step:` appearing **earlier** in the same `flows.<name>.steps` list, or a
variable introduced by an enclosing construct (for example a loop binding). Forward and self
references to steps are errors (§4.1).

### 1.2 Observed corpus

```text
{create.response.body.order_id}                     scalar field
{create.response.body.0.id}                         array index then field
{create.response.body.data.id}                      nested object
{item.response.body.1}                              terminal index
{item.response.body.answers.2.answer}               numeric OBJECT KEY (not an index)
{item.response.body.answers.169291c1.textAnswers.answers.0.value}
```

### 1.3 The numeric-segment ambiguity — normative resolution rule

`identifier` and `index` overlap: both match `0`, `2`, `169291c1`. The corpus contains **both
readings**:

- `{create.response.body.0.id}` — `0` indexes a PostgREST **array**.
- `{item.response.body.answers.2.answer}` — `2` is a **key** in the Google Forms `answers` **object**.

A purely lexical grammar cannot tell these apart. Resolution is therefore **type-directed**, decided
against the runtime value, not the text:

> **Rule R1.** For a numeric segment `n` applied to container `C`:
> - if `C` is an **array** → `n` is a zero-based index;
> - if `C` is an **object** → `n` is a literal key, matched as the string `"n"`;
> - if `C` is neither → error `E_PATH_TYPE` (§4.1).
>
> An object is never index-accessed and an array is never key-accessed. There is no fallback
> between the two: if an array has no element `n`, that is `E_PATH_RANGE`, **not** a key lookup.

This rule is the most important thing in this document. An implementation that guesses lexically
(treating all-digit segments as indices) breaks every AppTalk contract in `app_talk_contract/`.

### 1.4 Reference form determines result type

**Braces are not decoration. They select string interpolation.** This is the rule most likely to
catch an author out, so it is stated first and plainly:

| Form | Written as | Result |
|---|---|---|
| Bare reference | `price: create.response.body.price` | Type **preserved** → `45000` |
| Interpolation | `price: "{create.response.body.price}"` | **String** → `"45000"` |

> **Rule R2.** A **bare reference** — the path as the entire value, with no braces — resolves to the
> referenced value with its JSON type intact. A number stays a number, a boolean stays a boolean,
> and an object or array is substituted whole.

> **Rule R3.** A path wrapped in `{...}` is **string interpolation** and always produces a string,
> whether or not it is the entire value. `"{create.response.body.price}"` yields `"45000"`, not
> `45000`.
>
> Within an interpolation, strings splice verbatim (no quoting, no escaping) and numbers and
> booleans use their JSON textual form. A value MAY contain several interpolations:
> `"eq.{create.response.body.0.id}"` is the common PostgREST case. There is no escape sequence for
> a literal `{` — see §5.

The practical consequence: use braces when you are building a string (a filter expression, a URL
fragment, a formatted message) and a bare reference when the destination field needs a real number,
boolean, array or object. Reaching for braces by habit on a numeric field silently sends a string,
and an API that rejects `"45000"` for an integer field will fail in a way the contract does not
explain.

No contract in this repository currently depends on the distinction — every braced whole-value
reference here targets a path or query parameter, where a string is correct. The rule still needs a
worked example in the repository so it is exercised rather than merely asserted.

### 1.5 Roots

`<step>.response.body` is the **only** root in the entire corpus.

Not observed, and therefore not specified: `.response.headers`, `.response.status`,
`.request.*`, and the `$state` / `$input` / `$context` / `$actor` roots from the retired
minimal and enterprise specs. Response status is reachable only through `tests.expect`, never
through an expression.

Header and status access are an obvious gap — asserting on a `Location` header or branching on a
status code is ordinary API-testing work with no expression today. Flagged as a roadmap item, not
invented here.

---

## 2. Predicate language (`tests.verify`)

### 2.1 Syntax

```ebnf
predicate     = path comparison literal ;
comparison    = "==" | "!=" ;
literal       = string | integer | boolean | "null" ;
string        = "'" { any-char - "'" } "'" ;      (* SINGLE quotes *)
integer       = [ "-" ] DIGIT { DIGIT } ;
boolean       = "true" | "false" ;
```

Each entry in a `verify:` list is one predicate, written as a YAML string. Paths appear **bare** —
no surrounding braces, unlike §1.

```yaml
verify:
  - "create.response.body.0.id != null"
  - "update.response.body.0.title == 'Updated E2E'"
  - "check.response.body.max_pages == 4"
  - "test_sync.response.body.success == true"
```

### 2.2 Scope — deliberately narrow

The corpus contains **only** `==` and `!=`. Every one of the 30+ predicates across both repos is a
single comparison. There are:

- no relational operators (`<`, `>`, `<=`, `>=`)
- no boolean connectives (`&&`, `||`, `!`)
- no parentheses, arithmetic, or function calls
- no path-to-path comparison — the right side is always a literal

This document specifies the observed language rather than a larger one, so that "conforms to the
spec" means something an implementation can actually be held to. Relational and boolean support is
a reasonable extension (see §6), but it should be added deliberately, with tests, not assumed.

### 2.3 Comparison semantics — PROPOSED

> **Rule R4.** Comparison is by JSON value and type. `4` (number) and `'4'` (string) are **not**
> equal. `null` compares equal only to JSON null.
>
> **Rule R5.** `!= null` is the idiomatic existence check and the corpus's most common predicate. It
> is true when the path resolves to any non-null value, and false when the path resolves to null.
> A path that does **not resolve at all** is an error (§4.2), not `false` — a typo'd field name must
> not silently pass an existence check.

R5 is the consequential one. The permissive alternative — unresolved path counts as null, so
`!= null` is merely false — turns every misspelling into a passing-then-failing test rather than a
loud one. Fail-loud matches the project's stated fail-closed posture.

### 2.4 Quoting inconsistency (defect)

`verify` uses **single** quotes; guardrail conditions (§3) use **double** quotes. Two expression
languages in one format with opposite string conventions is a needless trap.

Recommendation: accept both in both languages, canonicalize on single quotes in documentation.
Cheap now, expensive after third-party implementations exist.

---

## 3. Guardrail condition language

A **separate** language, used by `guarded-service` and `skill` contracts. It does not share paths,
quoting, or operators with §§1–2, and should not be described as the same thing.

```ebnf
condition     = or-expr ;
or-expr       = and-expr { "||" and-expr } ;
and-expr      = primary { "&&" primary } ;
primary       = "(" condition ")" | comparison-expr ;
comparison-expr = variable operator value ;
operator      = "==" | "!=" | "<" | "<=" | ">" | ">=" ;
variable      = identifier ;
value         = '"' { any-char - '"' } '"' | number | boolean ;
```

```yaml
when: action == "create_refund" && amount <= 500
when: action == "read_customer_data" && (column == "credit_card" || column == "ssn")
when: action == "push" && branch == "main"
```

`variable` is an unqualified name resolved against the **call frame**: the reserved name `action`
(the invoked intent or tool), plus each key of the call's flattened `args`. Unlike §1 there is no
dotted path and no step reference.

> **Rule R6.** `action` is the **bare intent key** as declared under `intents:` (skill) or `tools:`
> (guarded-service). It carries no namespace and no dotted form.

**Known conformance bug.** `skills/github/github-skill.yaml` matches `"git.push"`,
`"github.create_pull_request"` and `"github.modify_file"` against intents declared as `git_push`,
`create_pull_request` and `modify_file`. No rule ever matches, every call falls to
`default: BLOCK`, and the demo blocks all three actions it advertises as allowed. Fix in that file.

> **Rule R7.** A variable that is absent from the call frame makes its comparison **false**; it is
> not an error. Guardrails must be evaluable against partial calls — `branch != "main"` has to be
> decidable for a call that carries no `branch` at all.

Note R7 is the deliberate **opposite** of R5. Assertions fail loudly on missing data; guardrails
degrade toward not-matching, so evaluation falls through to the next rule and ultimately to
`default: BLOCK`. Both directions are fail-closed for their context, which is the property that
matters.

### 3.1 Rule evaluation

> **Rule R8.** Guardrails are evaluated **in document order; first match wins**. Evaluation stops at
> the first rule whose condition is true, and that rule's `decision` is the outcome. If no rule
> matches, `default.decision` applies. `default` MUST be present, and MUST be `BLOCK` for any
> contract bound to a production system.

Order-dependence is load-bearing. `skills/supabse/supabase.yaml` is correct only because
`block_customer_pii` precedes `allow_safe_customer_data`; swapping the two silently permits reading
`ssn`. An implementation that reorders, parallelizes or de-duplicates rules breaks that contract
with no error surfaced.

### 3.2 A second, incompatible guardrail dialect

The reserved policy types (`hook-policy`, `shell-detection` — see the specification §1.1) do **not**
use `when:`. They use a structured matcher:

```yaml
guardrails:
  - id: git-block-force-push
    match:
      command: push
      args_any: ["--force", "-f"]
    decision: block
    message: Force push is not allowed.
```

Matcher keys: `command`, `command_any`, `command_contains`, `args_any`, `branch_any`. Semantics:
keys within one `match` are **AND**ed; `*_any` lists are **OR**ed; `*_contains` is substring, not
glob or regex. The `shell-detection` type further replaces `decision:` with `severity:` plus a
machine-readable `code:` — the only machine-stable rule identifier in the format, and a good
candidate for promotion to all policy types.

These are two languages doing one job. Unifying them is a larger decision than this document makes;
the minimum is that both are named so neither is mistaken for the other.

Recommendation for new work: structured `match:` should become canonical. It is safely
machine-analyzable, whereas `when:` requires an expression parser in every implementation and
invites injection through unvalidated `args`.

### 3.3 Decision value casing (defect)

Decision values appear in **both cases** across shipping contracts:

| Value | Uppercase | Lowercase |
|---|---|---|
| allow | `ALLOW` ×19 | `allow` ×8 |
| block | `BLOCK` ×10 | `block` ×17 |
| approval required | `APPROVAL_REQUIRED` ×1 | `approval_required` ×5 |

Split roughly along dialect lines — `when:` files favor uppercase, `match:` files lowercase — but
not cleanly, and nothing documents it. An implementation doing an exact string comparison will
mis-handle half the corpus, and a mis-handled `BLOCK` fails **open**.

> **Rule R9.** Decision values are **case-insensitive** on input. Canonical form in documentation is
> uppercase (`ALLOW`, `BLOCK`, `APPROVAL_REQUIRED`). An unrecognized decision value MUST be treated
> as `BLOCK`, never as allow.

---

## 4. Error behavior

Reference-resolution failure behavior is **confirmed engine behavior**, not inference: a reference
that cannot be resolved fails the step, and the outbound request is never sent. Predicate and
guardrail error handling (§§4.2–4.3) remain specified-by-design rather than confirmed.

### 4.1 Reference errors (§1)

| Code | Condition | Behavior |
|---|---|---|
| `E_STEP_UNKNOWN` | `step-id` names no earlier step | Fail the step before the request is sent |
| `E_STEP_ORDER` | reference to a later or the current step | Fail at contract-load time — statically detectable |
| `E_PATH_MISSING` | segment absent from container | Fail the step |
| `E_PATH_RANGE` | array index out of bounds | Fail the step |
| `E_PATH_TYPE` | segment applied to a scalar; object/array in embedded context (R3) | Fail the step |

> **Rule R10.** A failed reference **aborts the step before the outbound request is made**, and the
> flow halts. It does not send a request with an empty or literal-braces value. An implementation
> that degrades a failed reference into an empty string is non-conforming.

This matters concretely: `id: "eq.{create.response.body.0.id}"` degrading to `id: "eq."` would send
a **PostgREST request with an empty filter**, which on a `DELETE` route matches every row. Silent
degradation on a chained delete is a data-loss bug, not a test failure. Fail-fast is the only safe
default for a format whose selling point is guardrails.

`E_STEP_ORDER` is detectable without running anything and belongs in the validator (§6).

### 4.2 Predicate errors (§2)

| Code | Condition | Behavior |
|---|---|---|
| `E_PATH_*` | any resolution failure on the left path | The predicate **fails** (per R5) — reported as an assertion failure naming the unresolved path, not as a false comparison |
| `E_PREDICATE_SYNTAX` | unparseable predicate | Fail at contract-load time |

A failed `verify` fails its test but does **not** halt an already-completed flow: all predicates in
a `verify` list are evaluated and reported together, so one run surfaces every failure rather than
only the first.

### 4.3 Guardrail errors (§3)

| Code | Condition | Behavior |
|---|---|---|
| — | variable absent from call frame | Comparison is **false** (R7). Not an error |
| `E_CONDITION_SYNTAX` | unparseable `when:` | Treat the rule as **non-matching** and continue, **and** surface a load-time validation error |
| — | no rule matches | `default.decision` applies |

> **Rule R11.** An unparseable guardrail MUST NOT be treated as matching, and MUST NOT abort
> evaluation in a way that skips `default`. A policy file that fails to parse must still deny.

---

## 5. Reserved and unspecified

Deliberately **not** specified, because the corpus does not exercise them and guessing would create
false compatibility:

- Escaping a literal `{` or `}` in a value string. No corpus example needs one. Until specified, a
  literal brace in an interpolated string is undefined — worth reserving `{{` early, before someone
  needs it.
- Whitespace inside references (`{ create.response.body.id }`). Never observed. Recommend rejecting.
- Path-to-path comparison in `verify`.
- Any root other than `<step>.response.body` (§1.5).
- Default values / null-coalescing for missing paths.
- Regex or glob in guardrail matchers — `*_contains` is substring only (§3.2).

---

## 6. Open items

1. **Disambiguate a bare reference from a literal string.** R2 makes an unbraced path resolve as a
   reference, which means any string value shaped like `a.b.c` is potentially a reference. The rule
   for telling them apart is unspecified — presumably the first segment must match a known binding,
   but that is an inference. A contract with a literal value such as `filename: my.report.name`
   needs a defined outcome. Related: whether **quoting** affects the decision — is
   `"create.response.body.id"` a bare reference or a literal string? Both spellings appear in
   practice, and they cannot both be right.
2. **Validator.** Rules R6, R8, R9, `E_STEP_ORDER` and `E_PREDICATE_SYNTAX` are statically
   checkable. A validator enforcing only those would catch the GitHub skill bug (§3) automatically.
3. **Conformance corpus** — small contracts, each exercising one rule, with expected outcomes. This
   is what makes an independent implementation verifiable, and what turns this document from prose
   into a specification. Prerequisite for 1.0.
4. **Decide before 1.0:** the two guardrail dialects (§3.2), and whether relational operators enter
   the predicate language (§2.2). Both are cheap now and breaking later.
