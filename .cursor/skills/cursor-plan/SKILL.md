---
name: cursor-plan
description: Generates a structured Markdown plan file optimized for handoff to a Cursor agent. Use when user says /cursor-plan or asks to create a plan for Cursor, export a plan for Cursor, or hand off a plan to Cursor.
---

# Cursor Plan

Generate a complete, self-contained implementation plan that a Cursor agent can execute without clarification.

## Inputs

Accept one of:

- Plain-text feature request or task description in chat
- Path to an existing spec or notes file
- Pasted context/requirements

If the request is ambiguous or missing key constraints, ask up to 3 targeted clarifying questions before writing the plan. Prefer `AskQuestion` for multiple-choice decisions. Do not over-ask — skip questions answerable by reading the repo.

## Core Principles

- **Self-contained**: every task must be executable by a Cursor agent with zero outside context.
- **Atomic tasks**: each row is one verifiable unit of work — no compound tasks.
- **Sequenced**: tasks ordered so each can run after the previous with no hidden dependencies.
- **Grounded**: reference actual file paths, function names, and component names found in the repo — not placeholders.

## Output Format

Display the plan as a single fenced markdown code block (do NOT write any files). Use this exact structure inside the block:

```markdown
# Plan: <Title>

**Date**: <YYYY-MM-DD>
**Objective**: <One sentence — what done looks like from the user's perspective>
**Scope**: <What is explicitly out of scope for this plan>

---

## Tasks

| #   | Task | Status  | Priority | Notes |
| --- | ---- | ------- | -------- | ----- |
| 1.1 | ...  | ⬜ Todo | High     | ...   |
| 1.2 | ...  | ⬜ Todo | High     | ...   |
| 2.1 | ...  | ⬜ Todo | Medium   | ...   |

---

## Context for Cursor Agent

<2–4 short paragraphs. Cover: relevant existing files and patterns to follow, tech constraints (framework versions, style conventions), what NOT to change, and any non-obvious architectural decisions that affect implementation.>

---

## Acceptance Criteria

- [ ] <Verifiable outcome 1>
- [ ] <Verifiable outcome 2>
- [ ] <Verifiable outcome 3>

---

## Open Questions

- <Any unresolved decisions the Cursor agent should flag before proceeding, if any>

---

## Work Log

<!-- Cursor agent: append progress notes, blockers, and decisions here as you work -->
```

## Task Table Rules

- **Phase grouping**: Group tasks by logical phase using the first digit (1.x setup, 2.x data/model, 3.x logic, 4.x UI, 5.x tests, 6.x cleanup).
- **Status values**: `⬜ Todo` / `🔄 In Progress` / `✅ Done` / `⏭ Skipped`
- **Priority values**: `High` / `Medium` / `Low`
- **Notes column**: Include the target file path or function name where applicable. Never leave this blank for High-priority tasks.
- **Numbering**: Use hierarchical numbering (1.1, 1.2, 2.1) so the user can instruct Cursor with "do 2.1–2.3" or "skip 4.x".
- **Task count**: 3-10 tasks. Fewer for tightly scoped work; more for multi-phase features. Never pad.

## Context Section Rules

The "Context for Cursor Agent" section is the most important part. A Cursor agent starting cold needs:

1. **Entry point**: the main file(s) it will touch first.
2. **Patterns to follow**: existing code to model the new work on (e.g., "follow the pattern in `src/hooks/useAuth.ts`").
3. **Constraints**: versions, linting rules, naming conventions, library choices already made.
4. **Blast radius**: what adjacent areas to leave untouched.

Read the repo before writing this section. Do not fabricate file paths.

## Acceptance Criteria Rules

- Each criterion must be independently verifiable by the Cursor agent.
- Prefer testable outcomes ("the `/api/users` route returns 401 when unauthenticated") over vague ones ("auth works").
- 3–6 criteria. Match the scope of the plan.

## After Displaying

1. Output a one-paragraph **Cursor Handoff Note** — plain-English briefing the user can paste as the first message to a Cursor agent session. Format:

> "Here is a plan for [title]. Read the plan above in full, then execute the tasks in order beginning at 1.1. Ask before skipping any High-priority task. Append progress notes to the Work Log section as you go."

2. Ask the user if they want to run `/audit-plan` or `/grill-plan` on the output before handing off.
