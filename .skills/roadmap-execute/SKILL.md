---
name: roadmap-execute
description: Implement a ROADMAP.md item end to end, fanning work out to subagents where it parallelizes. Use when the user says /roadmap-execute, or asks to implement/build/execute a roadmap item by ID like [016].
argument-hint: "[NNN] — the roadmap item ID"
---

# Roadmap Execute

Implement one `ROADMAP.md` item. The `/roadmap` skill owns the file's format, status vocabulary, and box-checking rules — follow it for every edit to `ROADMAP.md`. This skill covers how the work gets done.

## 1. Load the item

Read `ROADMAP.md`. Find the item by ID.

- **No ID given** → list the `next` items with one-line summaries, ask which.
- **ID not found** → check `ROADMAP_DONE.md` before saying it doesn't exist.
- **`Depends On` lists an unfinished item** → say so and ask whether to proceed anyway. Do not silently build on a missing dependency.
- **Scope says PLACEHOLDER, or acceptance criteria are vague enough that two readings give different code** → stop and run `/grill-me` instead. Executing an unspecced item wastes the whole run.

Set `Status` to `next` if it isn't already.

## 2. Fan out

Subagents are explicitly requested by this skill — use the `Agent` tool freely here without asking.

**Recon first, in parallel.** Before writing anything, dispatch `Explore` agents at the unknowns the item names — one per surface (controller path, model/migration state, view layer, existing tests, similar prior implementations). These are read-only and safe to run many at once. Do not start editing until they report.

**Then implement.** Split the item's scope into chunks that touch **disjoint files**. One `general-purpose` agent per chunk, all in one message so they run concurrently. Chunks that would edit the same file are not parallel — do those yourself, in sequence.

Model per agent:

| Work | Model |
| --- | --- |
| Recon, file discovery, "where is X" | `haiku` or `sonnet` |
| Mechanical edits with a clear spec — migrations, form fields, view tweaks, test scaffolds | `sonnet` |
| Design decisions, cross-cutting refactors, anything touching auth, money, or production data | `opus` |
| Final review of the assembled diff | `opus` |

Each agent starts cold. Every brief must carry: the item's Goal, the specific acceptance criteria it owns, the exact file paths from recon, the repo conventions that apply, and an instruction to report what it changed. Do not make an agent re-derive context you already have.

**Do the work inline instead** when the item is a single file, a config change, or small enough that briefing an agent costs more than doing it. Fan-out is for breadth, not ceremony.

## 3. Test-first

Per `/roadmap`: write each test in `### Tests`, run it, confirm it fails for the right reason, then implement until it passes. A test that passes on first run is asserting nothing.

If the item has no `### Tests` section, add one before implementing. Name concrete paths.

Run the suite yourself after agents report. Do not trust a subagent's claim that tests pass — an agent reporting green is a claim, the observed run is the evidence.

## 4. Close out

- Check each `### Tests` box only after an observed pass.
- Check each acceptance criterion the work actually satisfies. Leave unmet ones unchecked and say which.
- Update `Scope` / `Technical Notes` if reality diverged from the plan.
- All boxes checked → set `Status` to `done` and prompt: "All criteria met for [NNN]. Run /roadmap-done to archive?"

**Stop before committing.** Leave the working tree dirty for review. Do not commit, branch, or push unless asked.

## Report

Short. What changed (files), what the tests show, what's unchecked and why. No narration of the fan-out.
