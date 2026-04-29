---
name: save
description: Append a structured summary of this session to the appropriate vault's daily log
trigger: /save
---

Summarize the current session and append a structured entry to the right vault based on the current working directory.

## Vault routing

1. Run `pwd` to get the current working directory.
2. Pick the vault by inspecting the path:
   - Path contains `/ENG/Berkshire` → **Berkshire vault** at `/Users/admin/Library/Mobile Documents/iCloud~md~obsidian/Documents/berkshire/`
     - Wiki index: `<vault>/wiki/index.md` (read for `[[ ]]` link resolution)
     - Project label: `Berkshire`
   - Otherwise → **personal vault** at `/Users/admin/Documents/Vault/Addison's Vault/`
     - Wiki index: `<vault>/wiki/index.md`
     - Project label: `Personal`
3. Sessions log path: `<vault>/sessions/<YYYY-MM-DD>.md`. Create the `sessions/` directory if missing.

## Steps

1. Compute `<DATE>` (`YYYY-MM-DD`) and `<TIME>` (`HH:MM`).
2. Read the vault's `wiki/index.md` if it exists. Use the concept names from there for `[[Page Name]]` resolution; everything else is `#kebab-case-tag`.
3. If the session was non-substantive (one prompt and abandoned, trivial check, no real work done), tell the user "nothing worth saving" and stop. Do not write anything.
4. Otherwise, build the entry below and append it to the log file. If the log file does not exist yet, prepend `# <project label> — <DATE>\n\n` before the entry. Always separate from prior content with a single blank line.

## Entry format

```
---
time: <HH:MM>
branch: <current git branch, or "unknown" / "n/a">
files: [<comma-separated relative paths of files EDITED or CREATED, not just read; empty list if none>]
concepts: [<comma-separated. Use "[[Page Name]]" only for concepts in the wiki index; otherwise "#kebab-case-tag". Empty list if none.>]
status: <completed|partial|blocked>
blockers: [<short one-sentence strings; empty list if none>]
followups: [<short one-sentence strings; empty list if none>]
---

## <HH:MM> — <distilled topic, max 8 words, no period>

- <bullet>
- <bullet>
- <... 3 to 8 bullets total. Match length to depth: short bug fix is ~3 bullets; substantive architecture decision up to 8.>
```

## Bullet rules

- Imperative voice / headline style. "Bump PAGE_DELAY 2 to 3." Not "I bumped..." or "We bumped..."
- Standup altitude. "Refactor color filter to handle null states." Not "Set product_colors[4] to COALESCE(...)."
- Capture decisions reached and their rationale.
- Capture new facts learned that compound into wiki value.
- DO NOT include: Read/Grep/Glob calls, narration like "I will start by...", files only read but not edited, failed approaches abandoned quickly, subagent dispatch boilerplate, token counts, timing meta, test/lint failures (the fix is what matters, not the failure).
- DO include: decisions, blockers, followups, consequential subagent results, real architectural insights.
- Do not quote the user verbatim.

## Frontmatter rules

- `files` lists ONLY files that were edited or created.
- `concepts` uses `[[Exact Name]]` only for concepts present in the wiki index; everything else is `#kebab-tag`.
- `status: completed` only if the user's stated goal was achieved. `partial` if meaningful progress without finishing. `blocked` if stuck.

After appending, report which vault was used, the path written, and the topic line. Nothing else.
