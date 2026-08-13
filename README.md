# agentic

A collection of my agentic resources, primarily skills I've created or customized. For my own use, YMMV.

## Sync `.skills` from GitHub

Run from the root of the project you want the skills in. Needs PowerShell and `git`.

No overwrite (adds new files, leaves existing ones alone):

```powershell
irm https://raw.githubusercontent.com/PSNapier/agentic/main/sync.ps1 | iex
```

With overwrite:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/PSNapier/agentic/main/sync.ps1))) -Force
```

Both forms sparse-clone this repo, copy `.skills/` into the destination, then delete the temp clone.

### Choosing where they land

The default destination is `.skills`, which is tool-agnostic. Point `-Dest` at whatever folder your agent actually reads: `.claude/skills` for Claude Code, `.cursor/skills` for Cursor, or anywhere else you prefer.

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/PSNapier/agentic/main/sync.ps1))) -Dest .claude/skills
```

`-Dest` accepts a relative or absolute path and combines with `-Force`.

## Skills (`.skills/<name>/SKILL.md`)

### `/caveman`

Invocable skill that matches the **caveman** rules and adds modes like **wenyan** and explicit persistence rules. Use when you want the same terse style with the full option set documented in the skill.

Source: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) — upstream also ships `caveman-compress`, `caveman-commit`, `caveman-review`, `caveman-stats`, and the `cavecrew` subagents.

_Note: this has been widely passed around as some sort of token efficiency boon. Since it's been tested more it doesn't actually appear to be that. However, I've enjoyed having it for the more concise output it creates. Anecdotally I have found this effect is less noticeable in Claude Code than Cursor, but still worthwhile... Claude seems more resistant to having their voice altered, so the wordage itself doesn't change as much, there's just less of it. Pre 5.0 iterations of Opus seemed to get a little grumpy/contrary with it implemented but that no longer seems to be the case._

### `/grill-me` (customized)

Based on Matt Pocock's grilling skill. There were aspects about his updated Grilling skills (Summer 2026) that didn't quite fit my brain or workflow, this is my customized version that puts questions back into the Claude Code question dialog, and organizes the grilling process more succinctly.

For instance, Before the changes I was seeing replies that would state a bunch of facts before asking a question with information on A, B, C, etc., all within the same paragraph and even the recommended answer, which was pulled out into another paragraph, would often have references to multiple options (again A, B, C, etc.).

Post-changes Questions are more directly and succinctly put in the Claude Code question dialog for clarity, while maintaining the improved frontiers functionality and other improvements.

Anecdotally I do feel this is an improvement over Pocock's original grilling skill. Even utilizing the same models, it seems to create more thorough and accurate resulting plans and specs.

Source: [mattpocock/skills](https://github.com/mattpocock/skills) (`grill-me`).

### `/roadmap`, `/roadmap-done`, `/roadmap-execute`, `/roadmap-scaffold` (custom)

My own planning loop, drafted with Opus 4.6(ish?) as a document outline and then tweaked over a lot of real sessions. Active work lives in `ROADMAP.md` at the repo root, finished work gets archived to `ROADMAP_DONE.md`. Items are three-digit IDs (`[002]`, `[015]`) with Goal, Scope, Technical Notes (optional Mermaid diagram), Acceptance Criteria, and a separate Tests section. Four statuses only: `next`, `blocked`, `freezer`, `done`, and nothing is `done` until every box in both sections is checked.

- `/roadmap` is the day-to-day one: add items, edit scope, check boxes, flip statuses.
- `/roadmap-done` reconciles the item against what actually happened at the end of a session, reruns the listed tests rather than trusting the diff, then archives and commits.
- `/roadmap-execute [NNN]` builds an item end to end, fanning recon and disjoint-file chunks out to subagents, test-first, and stops before committing so I can review the dirty tree.
- `/roadmap-scaffold` writes the two blank Roadmap files into a new project with example items.

My typical workflow is:

- `prompt /roadmap /grill-me` session 
- Implemented with `/goal roadmap-execute [roadmap-item-id]`
- Once confirmed working/done `ROADMAP.md` and `ROADMAP.md` are updated and changes are committed with `/roadmap-done`.

_Note: It seems the standard at large for this sort of workflow is to utilize something that interfaces with GitHub issues or a service like Linear. For my particular process that felt needlessly complicated, and I like having the whole roadmap documents open in my editor as I am working with Claude Code. I expect this type of workflow is well suited to solo devs but less so for group projects (though I imagine work arounds such as different sections within the road maps for different devs)._

### `/startup-design`

Takes an idea through eight phases: intake, brainstorm, research, strategy, brand, product, financials, validation—mostly as markdown artifacts plus `PROGRESS.md` for resuming. Optional fast-track when you want a quicker go/no-go. Supporting material lives under `startup-design/references/` (research waves, synthesis, benchmarks, honesty protocol, etc.).

Source: [ferdinandobons/startup-skill](https://github.com/ferdinandobons/startup-skill) (`startup-design`; the same repo also ships `startup-competitors`, `startup-positioning`, and `startup-pitch`).
