---
name: roadmap-done
description: Close out a roadmap item at end of session, reconcile ROADMAP.md against work actually completed (check boxes, set status to done), then archive the item to ROADMAP_DONE.md. Use when the user says /roadmap-done, finishes a session and wants to wrap up an item, or asks to archive [NNN].
---

# Roadmap Done

End-of-session closeout: update `ROADMAP.md` to reflect completed work, then move the item to `ROADMAP_DONE.md`.

## When to Use

- User says `/roadmap-done`
- End of a session where work on `[NNN]` is complete but `ROADMAP.md` not yet reconciled
- User asks to archive `[NNN]`

## Assumption

`ROADMAP.md` may be **out of date**. Acceptance boxes may still be `- [ ]` even though the work happened. Do not refuse to proceed, reconcile first.

## Procedure

### 1. Identify the item

- Ask user which `[NNN]` if ambiguous
- Read the item block from `ROADMAP.md`

### 2. Reconcile against session work

The two sections take different kinds of evidence. Reconcile them separately.

**`### Tests`** — run them, do not infer from the diff. Run the item's listed tests (the minimum set needed, filtered by name or file). For each `- [ ]`:

- **Test exists and passes** → propose checking it
- **Test fails, errors, or is skipped** → leave unchecked, report the failure output
- **Test does not exist yet** → leave unchecked. Offer to write it
- **Test passes but asserts a truism, or was never seen to fail** → flag it, do not check

**`### Acceptance Criteria`** — judge against session work, passing tests, and anything the user confirms. For each `- [ ]`:

- **Clearly satisfied** → propose checking it
- **Partially done or unclear** → flag to user, do not check
- **Not done** → leave unchecked

Present both sections to the user, showing the evidence behind each line:

```
[002] Admin Character Review Panel

Tests:
  - [x] AdminPanelTest::sorts_by_missing_data      (PASS)
  - [x] AdminPanelTest::opens_modal_with_da_data   (PASS)
  - [ ] AdminPanelTest::approves_character         (FAIL, modal still read-only)

Acceptance Criteria:
  - [x] Admin can sort table by missing data type        (covered by passing test)
  - [x] Modal opens with DA description data on row click (covered by passing test)
  - [ ] Admin can approve/reject/edit...                  (NOT done, modal still read-only)

Status: next → ??? (open boxes remain; cannot archive yet)
```

### 3. Decide path

- **All criteria check off** → proceed to step 4 (update + archive)
- **Some criteria remain** → stop. Update `ROADMAP.md` with the verified checkboxes, leave `Status` as `next` (or `blocked` if work cannot continue), tell user item cannot be archived yet. Done.
- **User overrides** (e.g. "criterion no longer relevant, drop it") → edit the criterion line per user instruction, then re-evaluate

### 4. Apply updates to ROADMAP.md

- Check the agreed boxes (`- [ ]` → `- [x]`)
- Set `**Status:**` to `done`
- Apply any agreed scope/criteria edits

### 5. Move item to ROADMAP_DONE.md

- Cut the full item block from `ROADMAP.md` (heading through trailing `---`)
- Remove any orphan `---` left behind in `ROADMAP.md`
- Insert at the **top** of `ROADMAP_DONE.md` (newest-first ordering), directly after the `# Roadmap Done` header, followed by a trailing `---` separator
- Preserve content verbatim during the move

### 6. Stage and commit

Only after the archive move is confirmed written.

1. Run `git status --short` and show the user what will be committed
2. If the current branch is the default branch (`main`/`master`), stop and ask before committing
3. `git add -A` (all working tree changes, not just roadmap files)
4. Commit with a message in this shape:

```
chore(roadmap): archive [NNN] Title

<one line per notable change made during the session>

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```

If the session's work is better described by a feature/fix commit, use that type instead (`feat:`, `fix:`) and mention the archive in the body.

Do not push. Leave that to the user.

### 7. Confirm

Report: `Archived [NNN] Title → ROADMAP_DONE.md` with summary of any criteria/scope edits made, plus the commit SHA and subject line.

## Safeguards

- Never check a box in `### Tests` without running that test and observing it pass in this session
- Never accept a green suite as proof without checking that the specific listed tests ran. A filter that matches nothing exits green
- Never check an acceptance criterion without evidence in session work or explicit user confirmation
- Never set `Status: done` if any `- [ ]` remains in **either** section
- Never write or weaken a test during closeout to make something pass. If a test is wrong, say so and stop
- Never delete from `ROADMAP.md` before confirming the append to `ROADMAP_DONE.md` succeeded
- Never renumber `[NNN]` IDs
- If the item is already in `ROADMAP_DONE.md` (duplicate), abort and tell user
- Never commit before the archive move is written and verified
- Never commit when the item could not be archived (step 3 "some criteria remain" path). Leave changes staged-free for the user
- Never push, force-push, amend, or skip hooks (`--no-verify`)
