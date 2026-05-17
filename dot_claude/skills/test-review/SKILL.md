---
name: test-review
description: Author-side review of test quality on the current change. Catches tautological asserts, over-mocking, mocked DBs, and snapshot abuse. Edits tests in place. Run before commit when the diff includes test files.
---

# Test review

Use this skill when the change adds or modifies tests, before commit. The goal is that tests actually exercise behavior — not that they pass.

## Scope

Only review test files that this change touched:

```
git diff --name-only main...HEAD | grep -E '(test_|_test\.|\.test\.|/tests/|/__tests__/)'
```

If the list is empty, stop — there's nothing to review.

## Failure modes to catch

### 1. Tautological assertions

For every assertion in the changed tests, ask: **would this still pass if the implementation returned `None`, `{}`, the input unchanged, or `True`?** If yes, the test is tautological.

Common shapes:
- `assert result is not None` as the only assertion
- `assert mock.called` without checking what it was called with or what came back
- `assert isinstance(result, dict)` with no check on contents
- `assertEqual(result, result)` patterns (asserting against another call to the same code path)
- Snapshot tests where the snapshot was generated from the broken implementation

**Fix:** assert on the actual value — the specific number, the specific row count, the specific error message. If the value is non-deterministic, assert on its shape *and* a property (range, sort order, length, key set).

### 2. Over-mocking

Count mock/patch usage in each changed test file:

```
grep -cE 'mock\.|MagicMock|@patch|monkeypatch|jest\.mock|vi\.mock' <file>
```

- **>5 per file** → flag for review. The test is probably mocking the thing under test.
- **Mocking the function being tested** → always wrong. Remove.
- **Mocking the database** in any test that exercises an ORM model, query, or migration → always wrong (see rule 3).

**Fix:** mock only at trust boundaries (external HTTP APIs, payment processors, email sending, the clock). Inside the system, use real objects.

### 3. Real DB for ORM/pipeline code

Any test that touches SQLAlchemy models, Alembic migrations, or the data pipeline must hit a real Postgres. Acceptable:
- `pytest-postgresql`
- `testcontainers`
- A persistent test DB the project already uses (check `conftest.py`)

Banned: `mock.patch` on `Session`, `engine`, `connection`, or any query method. If you find this, replace with a real DB fixture.

### 4. Snapshot abuse

Snapshot tests are flagged when:
- The snapshot is >50 lines (split or assert on specific properties)
- The snapshot includes timestamps, UUIDs, or other volatile output (normalize first)
- The PR adds a snapshot without a comment explaining what behavior it pins down

**Fix:** snapshots are for genuinely stable output (rendered HTML, formatted reports). For everything else, write specific assertions.

### 5. Coverage-without-behavior

A test that imports a module and instantiates a class without exercising any behavior. Hits coverage lines, asserts nothing meaningful.

**Fix:** delete it, or add a real assertion on the behavior you intended to cover.

## Process

1. Identify changed test files (command above).
2. For each file:
   - Read the file fully.
   - For each test function, list its assertions and answer the tautology question above.
   - Run the mock count.
   - Check for DB mocking if the test touches models/queries.
   - Check snapshot rules if `.snap` / `toMatchSnapshot` / `syrupy` is involved.
3. Apply fixes in place. If a fix would require widening scope (e.g. introducing a `pytest-postgresql` fixture the project doesn't have), surface it as a finding instead of fixing.
4. Re-run the affected tests after edits: `pytest <file>` or `npm test -- <file>`. Confirm they still pass and that at least one assertion in each changed test would *fail* if the implementation regressed (mentally apply the tautology check).

## Stop rules

- Do not add new tests beyond fixing the ones in the diff.
- Do not refactor unrelated test infrastructure.
- Do not change production code from this skill — if a test reveals a bug, surface it; don't silently fix it.
- If the project genuinely lacks a real-DB fixture and adding one is out of scope, leave the test mocked and add a `# TODO(test-review): replace DB mock with real fixture` comment with the date.

## Output

Brief summary at the end:
- Files reviewed
- Fixes applied (file:line, what changed)
- Findings surfaced but not fixed (with reason)
