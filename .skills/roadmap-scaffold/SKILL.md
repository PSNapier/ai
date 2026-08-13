---
name: roadmap-scaffold
description: Scaffolds blank ROADMAP.md and ROADMAP_DONE.md files at the project root using the project's standard format. Use when the user says /roadmap-scaffold, wants to initialize a new project's roadmap, or asks to create blank/example roadmap files.
disable-model-invocation: true
---

# Roadmap Scaffold

Creates `ROADMAP.md` and `ROADMAP_DONE.md` at the project root.

## Steps

1. Check if either file already exists. Warn if so and ask before overwriting.
2. Write `ROADMAP.md` using the template below.
3. Write `ROADMAP_DONE.md` using the template below.
4. Tell the user the files were created and to use the `/roadmap` skill to manage them.

---

## ROADMAP.md Template

```markdown
# Roadmap

## [001] Example Task Title

**Status:** `next`
**Depends On:** none

### Goal

One-paragraph description of what this task accomplishes and why.

### Scope

- What is included
- What is NOT included (call it out explicitly)

### Technical Notes

- Implementation details, constraints, relevant files/tables/commands

### Acceptance Criteria

- [ ] Criterion one
- [ ] Criterion two
- [ ] Criterion three

### Tests

Written test-first: each test is written and watched to fail before the code that makes it pass.

- [ ] `path/to/ExampleTest::it_does_the_thing`
- [ ] `path/to/ExampleTest::it_handles_the_edge_case`
- [ ] `path/to/ExampleTest::it_rejects_bad_input`

---
```

**Status values:** `next` · `blocked` · `freezer` · `done`

---

## ROADMAP_DONE.md Template

```markdown
# Roadmap Done

## [001] Example Completed Task

**Status:** `done`
**Depends On:** none

### Goal

One-paragraph description of what this task accomplished and why.

### Scope

- What was included
- What was explicitly out of scope

### Technical Notes

- Key implementation decisions and relevant files/tables/commands

### Acceptance Criteria

- [x] Criterion one
- [x] Criterion two
- [x] Criterion three

### Tests

- [x] `path/to/ExampleTest::it_does_the_thing`
- [x] `path/to/ExampleTest::it_handles_the_edge_case`
- [x] `path/to/ExampleTest::it_rejects_bad_input`

---
```

---

## Notes

- `### Acceptance Criteria` are plain checkable outcomes. `### Tests` is a separate section listing the automated coverage, written test-first: the test is watched to fail before the code that makes it pass, and its box is checked once it passes. An item is not `done` until every box in both sections is checked.
- Tests need not map one-to-one onto criteria. Some criteria are verified by hand (visual, editorial, third-party), in which case note how in `Technical Notes`.
- New item IDs are assigned by scanning both `ROADMAP.md` and `ROADMAP_DONE.md` for the highest `[NNN]` and incrementing. There is no counter comment to maintain.
- Bullet style is `- ` (dash + single space) throughout.
- When an item is completed, move it from `ROADMAP.md` into `ROADMAP_DONE.md` (prepend, newest first). Use the `/roadmap-done` skill.
- The `**Spec:**` field is optional. Add it below `Depends On` when a separate spec file exists: `**Spec:** path/to/spec.md`
- `**Depends On:**` takes a comma-separated list of item IDs or `none`.
