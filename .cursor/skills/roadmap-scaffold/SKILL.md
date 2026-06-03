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
4. Tell the user: files created, next task number to set, and to use `/roadmap` skill to manage them.

---

## ROADMAP.md Template

```markdown
# Roadmap

<!-- Next task number: [002] -->

## [001] Example Task Title

**Status:** `next`
**Priority:** low
**Depends On:** none

### Goal

One-paragraph description of what this task accomplishes and why.

### Scope

- What is included
- What is NOT included (call it out explicitly)

### Technical Notes

- Implementation details, constraints, relevant files/tables/commands
- Add a `**Spec:**` frontmatter field above if a separate spec file exists

### Acceptance Criteria

- [ ] Criterion one
- [ ] Criterion two
- [ ] Criterion three

---
```

**Status values:** `next` · `in-progress` · `freezer` · `blocked`

**Priority values:** `high` · `low`

---

## ROADMAP_DONE.md Template

```markdown
# Roadmap Done

## [001] Example Completed Task

**Status:** `done`
**Priority:** medium
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

---
```

---

## Notes

- Increment `<!-- Next task number: [NNN] -->` comment each time a new item is added to `ROADMAP.md`.
- When an item is completed, move it from `ROADMAP.md` into `ROADMAP_DONE.md` (prepend, newest first). Use the `/roadmap-done` skill.
- The `**Spec:**` field is optional — add it when a separate spec file exists: `**Spec:** path/to/spec.md`
- `**Depends On:**` takes a comma-separated list of item IDs or `none`.
