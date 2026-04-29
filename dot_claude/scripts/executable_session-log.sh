#!/usr/bin/env bash
# Claude Code SessionEnd hook — append a structured session summary to a project's
# daily session log file (YYYY-MM-DD.md).
#
# Plumbing patterns adopted from shannhk/llm-wikid (MIT) update-hot-cache.sh:
# claude -p with --output-format text, hard timeout, fire-and-forget background.
#
# Designed to be invoked from a project's .claude/settings.local.json SessionEnd
# hook with three env vars set on the command. If SESSIONS_DIR is unset the script
# exits silently — safe to invoke from any project that has not opted in.
#
#   SESSIONS_DIR  (required) directory where YYYY-MM-DD.md daily logs accumulate
#   WIKI_INDEX    (optional) path to wiki/index.md for [[ ]]-linking known concepts
#   PROJECT_NAME  (optional) project label used in the summarization prompt

set -u

# Opt-in gate
if [[ -z "${SESSIONS_DIR:-}" ]]; then
  exit 0
fi

# Read hook event JSON from stdin
HOOK_INPUT="$(cat 2>/dev/null || true)"

# Extract transcript path (jq if available, fallback to grep/sed)
TRANSCRIPT_PATH=""
if command -v jq >/dev/null 2>&1; then
  TRANSCRIPT_PATH="$(printf '%s' "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)"
fi
if [[ -z "$TRANSCRIPT_PATH" ]]; then
  TRANSCRIPT_PATH="$(printf '%s' "$HOOK_INPUT" | grep -oE '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]+"' | sed 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || true)"
fi

if [[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 0
fi

# Extract session_id for deduplication (jq if available, fallback to grep/sed)
SESSION_ID=""
if command -v jq >/dev/null 2>&1; then
  SESSION_ID="$(printf '%s' "$HOOK_INPUT" | jq -r '.session_id // empty' 2>/dev/null || true)"
fi
if [[ -z "$SESSION_ID" ]]; then
  SESSION_ID="$(printf '%s' "$HOOK_INPUT" | grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]+"' | sed 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || true)"
fi

mkdir -p "$SESSIONS_DIR"
DATE="$(date +%Y-%m-%d)"
TIME="$(date +%H:%M)"
LOG_FILE="$SESSIONS_DIR/$DATE.md"
PROJECT="${PROJECT_NAME:-this project}"

# Deduplicate: if today's log already has an entry for this session_id, bail.
# Resume events fire SessionEnd on the prior session, leading to duplicate summaries
# without this guard.
if [[ -n "$SESSION_ID" && -f "$LOG_FILE" ]] && grep -qF "session_id: $SESSION_ID" "$LOG_FILE"; then
  exit 0
fi

WIKI_INDEX_BLOCK="(no wiki index configured — use #kebab-tags for all concepts)"
if [[ -n "${WIKI_INDEX:-}" && -f "$WIKI_INDEX" ]]; then
  WIKI_INDEX_BLOCK="$(cat "$WIKI_INDEX")"
fi

PROMPT="You are summarizing a Claude Code session transcript for the $PROJECT daily log.

Read the transcript at: $TRANSCRIPT_PATH

If the session was non-substantive (one prompt and abandoned, trivial check, no real work done), output exactly:

SKIP

Otherwise output ONLY the markdown entry below — no preamble, no commentary, no fences. The output must start with the YAML frontmatter --- line:

---
time: $TIME
branch: <git branch from transcript context, or \"unknown\">
files: [<comma-separated relative paths of files EDITED or CREATED, not just read; empty list if none>]
concepts: [<comma-separated concepts touched. Use \"[[Page Name]]\" only for concepts present in the wiki index below; otherwise \"#kebab-case-tag\". Empty list if none.>]
status: <completed|partial|blocked>
blockers: [<short one-sentence strings; empty list if none>]
followups: [<short one-sentence strings; empty list if none>]
session_id: <session id from transcript JSON if available, else \"unknown\">
---

## $TIME — <distilled topic, max 8 words, no period>

- <bullet>
- <bullet>
- <... 3 to 8 bullets total. Match length to depth: short bug fix is ~3 bullets; substantive architecture decision up to 8.>

Bullet rules:
- Imperative voice / headline style. \"Bump PAGE_DELAY 2 to 3.\" Not \"I bumped...\" or \"We bumped...\"
- Standup altitude. \"Refactor color filter to handle null states.\" Not \"Set product_colors[4] to COALESCE(...).\"
- Capture decisions reached and their rationale.
- Capture new facts learned about the codebase that compound into wiki value.
- DO NOT include: Read/Grep/Glob calls, narration like \"I will start by...\", files only read but not edited, failed approaches abandoned quickly, subagent dispatch boilerplate, token counts, timing meta, test/lint failures (the fix is what matters, not the failure).
- DO include: decisions, blockers, followups, consequential subagent results, real architectural insights.
- Do not quote the user verbatim.

Frontmatter rules:
- \"files\" lists ONLY files that were edited or created.
- \"concepts\" uses \"[[Exact Name]]\" only for concepts present in the wiki index below; everything else is \"#kebab-tag\".
- \"status: completed\" only if the user's stated goal was achieved. \"partial\" if meaningful progress without finishing. \"blocked\" if stuck.

Wiki index for [[ ]] resolution (existing concept pages — match these names exactly):

$WIKI_INDEX_BLOCK"

# Fire-and-forget in background. The wrapping subshell won't block hook return.
# Pure-bash timeout via background watchdog — no GNU coreutils required.
(
  OUT_FILE="$(mktemp -t session-log-out.XXXXXX)"
  trap 'rm -f "$OUT_FILE"' EXIT

  claude -p "$PROMPT" --output-format text > "$OUT_FILE" 2>/dev/null &
  CLAUDE_PID=$!
  ( sleep 120; kill -TERM "$CLAUDE_PID" 2>/dev/null; sleep 2; kill -KILL "$CLAUDE_PID" 2>/dev/null ) &
  WATCHDOG_PID=$!
  wait "$CLAUDE_PID" 2>/dev/null
  kill "$WATCHDOG_PID" 2>/dev/null
  wait "$WATCHDOG_PID" 2>/dev/null

  OUTPUT="$(cat "$OUT_FILE" 2>/dev/null || true)"

  if [[ -z "$OUTPUT" ]]; then
    {
      [[ ! -s "$LOG_FILE" ]] && printf '# %s — %s\n\n' "$PROJECT" "$DATE"
      printf '\n## %s — summarization failed\n\nTranscript: `%s`\n' "$TIME" "$TRANSCRIPT_PATH"
    } >> "$LOG_FILE"
    exit 0
  fi

  # SKIP detection: if the output is a "decline to summarize" rather than a real
  # entry — i.e., does NOT start with "---" frontmatter, AND contains the word SKIP
  # as a standalone token — treat as a skip. This catches both bare "SKIP" and
  # the LLM's occasional habit of adding a sentence of explanation before SKIP.
  if [[ "$OUTPUT" != ---* ]] && printf '%s' "$OUTPUT" | grep -qwE 'SKIP'; then
    exit 0
  fi

  # Output didn't start with --- frontmatter and didn't say SKIP — log as malformed.
  if [[ "$OUTPUT" != ---* ]]; then
    {
      [[ ! -s "$LOG_FILE" ]] && printf '# %s — %s\n\n' "$PROJECT" "$DATE"
      printf '\n## %s — malformed summary\n\nTranscript: `%s`\n\nRaw output:\n\n%s\n' "$TIME" "$TRANSCRIPT_PATH" "$OUTPUT"
    } >> "$LOG_FILE"
    exit 0
  fi

  {
    [[ ! -s "$LOG_FILE" ]] && printf '# %s — %s\n\n' "$PROJECT" "$DATE"
    printf '\n%s\n' "$OUTPUT"
  } >> "$LOG_FILE"
) &

exit 0
