---
name: grill-me
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the frontier, wait for answers, recompute. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them.

## How to ask

**Always use the `AskUserQuestion` tool. Never ask in prose.** This works in any mode — do not enter plan mode to get it.

- Max 4 questions per call. If the frontier is wider, ask the 4 with the largest blast radius and carry the rest to the next round.
- 2-4 options each. Put your recommendation **first** and suffix its label with `(Recommended)`.
- Option `label`: 1-5 words. Option `description`: one sentence — the tradeoff, not a restatement.
- The question body carries the stakes in one or two sentences. No paragraphs, no nested option lists — the options are the options.
- Use the `preview` field only when the choice is a concrete artifact worth seeing side by side (layouts, snippets, schemas).
- An open-ended question still becomes options. "Is X the target, or also Y?" is two options, not prose.

## Facts

Finding facts is your job, never the user's. Dispatch sub-agents or tools to look things up — never ask the user for anything you could find yourself. Don't block: a running exploration is an unsettled prerequisite, so only its downstream questions wait. Ask the rest of the frontier now.

**Do not narrate the search and do not dump a fact table.** A fact reaches the user only when it changes an answer, and then only as one line — inside the question body or an option description, cited as `file:line`. If the user wants more, they will ask.

## Budget

At most two sentences of narration between rounds, and only when the tree actually reshaped ("Q2 killed the fallback path — that collapses Q5 and Q6 into one"). Otherwise go straight to the next `AskUserQuestion` call.

## Done

The session ends when the frontier is empty: every branch visited, nothing silently assumed. Do not start building until the user confirms shared understanding.
