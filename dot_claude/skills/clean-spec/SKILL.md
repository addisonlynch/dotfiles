---
name: clean-spec
description: Transform a spec into a clean final-state document by removing references to past approaches, alternatives, and comparisons, and rewriting negations into positive constraints.
user-invocable: true
---

Transform this into a final-state spec.

Rewrite (not remove) any negation, contrast, or comparison into a positive constraint.
- Example: "No ORM" → "Database access uses psycopg v3 directly."
- Example: "Instead of polling, we use webhooks" → "The system receives updates via webhooks."

Delete only sentences whose sole purpose is to relitigate a rejected alternative that adds no constraint to the final state (e.g. "We considered Redis but chose Postgres because…"). If a rejected alternative carries a real constraint, keep the constraint in positive form.

**Preserve, do not delete:**
- **Context / background / motivation sections.** The "why" behind the spec stays. Rewrite any past-tense pain points into present-tense goals or constraints, but keep the section.
- **Audit / current-state sections** when they describe facts about the system the spec acts on (file paths, line numbers, existing behavior). Rewrite verdict language ("this is wrong," "should be better") into neutral present-tense statements of the current fact. Delete an audit row only if it contains no fact the implementer needs.
- **Goals, decisions, constraints, file paths, line citations, numeric values, cost figures, verification steps.**
- Any section the user would lose information by not having.

Rules:
- Preserve all concrete decisions, constraints, and factual context.
- Convert everything into concise, positive, present-tense statements.
- Do not introduce new information.
- When in doubt, rewrite rather than delete. Deletion is reserved for pure comparison/justification prose with no factual residue.

Before finalizing, list any sections you deleted entirely (not just rewrote) and confirm each one contained no concrete facts, paths, or constraints the implementer would need. If a deleted section did contain such facts, restore it in rewritten form.

Output should read as a clean source-of-truth spec that a new reader can act on without missing context.
