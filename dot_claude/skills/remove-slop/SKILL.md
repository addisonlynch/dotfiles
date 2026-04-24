---
name: remove-slop
description: Find and remove AI-generated filler — unnecessary comments, over-documentation, verbose error handling, and bloated abstractions
---

Scan the codebase for common AI slop patterns and clean them up. Focus on code that adds verbosity without value.

## What to look for

### Unnecessary comments
- Comments that restate the code: `# Get the user` above `get_user()`
- Obvious docstrings: `"""Initialize the class."""` on `__init__`
- Section dividers that add no information
- TODO comments with no actionable detail

### Over-documentation
- Docstrings on private methods or simple helpers that merely restate the function name/signature
- Type annotations repeated in docstrings when already in signatures
- README-style explanations inline in code

### Verbose error handling
- Try/except blocks that just re-raise with a worse message
- Unnecessary fallback values that hide bugs
- Overly defensive None checks on values that can't be None

### Bloated abstractions
- Wrapper functions that add no logic
- Single-use utility functions that obscure the actual operation
- Over-engineered class hierarchies for simple operations
- Configuration objects for things with one caller

### Filler patterns
- `print("Starting...")` / `print("Done!")` style logging with no value
- Redundant type conversions (`str(some_string)`)
- Empty `__init__.py` files with module docstrings

## Rules

- Only remove what is clearly filler. If in doubt, leave it.
- Do not change logic or behavior — only remove noise.
- Run `/lint` after cleanup to ensure nothing broke.
- Report what was removed and why, grouped by file.
