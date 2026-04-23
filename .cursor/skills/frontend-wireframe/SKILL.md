---
name: frontend-wireframe
description: >-
     Layout and UX-only wireframes: two fixed Tailwind neutrals, border-only regions, mobile-first
     single column, header + hamburger (top-right) with full right-aligned menu, desktop at `lg`
     with centered max-width shell. Infer deliverable + routes from the repo; ask if unclear. Use when
     the user mentions wireframe, page layout, site structure, landing/pricing shells, mobile nav,
     or asks to apply this skill explicitly.
---

# Frontend wireframe (layout + UX)

Use this skill for **structure and interaction only**. Ignore branding, imagery, typography beyond defaults, gradients, and dark/light themes. When the user wants real visual design, switch to `frontend-implementation` (and optionally `frontend-design`).

## URLs and screenshots as layout reference

When the user supplies a **site URL**, **screenshot**, or similar reference, use it to infer **layout and UX**: section order, columns vs stacks, header/nav behavior, grouping, rough proportions, and interactive patterns. **Match that structure as closely as is practical** in the wireframe deliverable.

Reference **styling must never override** this skill’s wireframe rules: keep the **two neutrals**, **border-only** region separation, and **Tailwind-first** styling. **Ignore** reference **colors, fonts, icons, logos, imagery, shadows, and decorative radii**—do not import them. For **icons** or small brand marks, use neutral placeholders (e.g. small **solid**-border box or the word `icon`). For **image-sized** areas, use **dashed**-border placeholders per the palette rules.

If the reference conflicts with mandatory patterns here (e.g. left hamburger vs this skill’s mobile header rule), **prefer this skill’s defaults** unless the user explicitly says to mirror the reference for that point.

## Palette (wireframe mode)

Use **exactly two** Tailwind neutral roles everywhere in generated markup:

| Role                    | Classes (fixed pair)                      |
| ----------------------- | ----------------------------------------- |
| Page background         | `bg-neutral-500`                          |
| Text, borders, outlines | `text-neutral-300` + `border-neutral-300` |

Rules:

- Do **not** use a second background shade to separate cards, sidebars, or sections. Same `bg-neutral-500` for the whole page (or full viewport behind a centered shell).
- Differentiate blocks **only** with `border` (and spacing). Optional: `rounded-sm` for corners; keep radius minimal. Use **solid** borders for structural regions by default (`border` / `border-solid`).
- **Image placeholders** (hero art, photos, illustrations, logos-as-image, large media slots): use **`border-dashed`** with the same `border-neutral-300` (e.g. Tailwind `border border-dashed border-neutral-300`). Optional fixed aspect with `aspect-*` or min-height; include a short visible label like `Image` or the block id so dashed boxes read as “media goes here,” not generic layout chrome.
- No extra neutrals, no semantic colors, no shadows for “depth” unless the user explicitly overrides.

## Tailwind and custom CSS

- **Default to Tailwind** utility classes for layout, spacing, flex/grid, borders, and the wireframe palette above. Prefer framework-idiomatic markup + classes over bespoke styling.
- **Avoid custom CSS** (no global edits to `app.css`, theme files, or new standalone stylesheets for wireframe work).
- **If you must deviate** (rare edge case Tailwind cannot cover cleanly), keep overrides **minimal** and **confined to the same file** as the page/component you are delivering—for example Vue SFC `<style scoped>`, or a single `<style>` block in that Blade file only. Do not leak wireframe-only rules into shared bundles.

## Responsive shell

1. **Mobile-first:** default layout is **one column** unless a section’s UX clearly needs otherwise (e.g. a documented comparison table).
2. **Header:** top bar with site title/placeholder on the left; **hamburger on the top-right** (LTR).
3. **Menu:** Tapping the hamburger reveals the **entire** nav set in a panel that is **right-aligned** (link block aligned to the end side) for thumb reach. Full viewport height panel; backdrop tap and `Escape` close; move focus into the panel when open and restore focus on close. Use project primitives (e.g. Headless UI `Dialog`) if present; otherwise minimal `ref` + `aria-expanded` / `aria-controls` on the button and an `id` on the panel.
4. **Desktop:** Apply multi-column / horizontal nav patterns at Tailwind **`lg`** (`lg:`) and up. Design desktop assuming **1280px** as the primary wide target.
5. **Very wide viewports:** Wrap main content in a centered shell, e.g. `max-w-7lg mx-auto px-4 sm:px-6 lg:px-8` (adjust `px` if the project already standardizes padding). No full-bleed content unless the user asks.

## Names, IDs, and on-canvas labels

- **Name every core region and control** you introduce (conceptually and in code): header chrome, mobile menu, main column, hero, pricing block, footer, primary CTA row, form groups, etc.
- Give each such element a **representative `id`** on its wireframe root (stable **kebab-case**, e.g. `site-header`, `nav-mobile`, `block-hero`, `block-pricing`). Use the same stem for related `aria-controls` / `aria-labelledby` / `<label for="…">` when the UX element needs it.
- For **visible UX modules** (bordered sections, cards, dialogs, major form areas—anything a stakeholder would point at), put the **name and/or `id` in the visible heading** for that module—typically the first heading inside the block, e.g. `Hero · block-hero` or `Pricing (block-pricing)`. If the element has **no** natural header slot (pure spacer, icon-only control with `aria-label` only), skip visible title but **keep the `id`**.

## Deliverable and routing

### Infer the artifact

Before creating files, **inspect the repo** for how pages are already built, for example:

- **`resources/js/Pages/`** with Vue + Inertia → new page as a **Vue SFC** there, wired like sibling pages.
- Same folder with React + Inertia → **React** page component instead.
- **`resources/views`** + `routes/web.php` (or similar) returning `view()` → **Blade** (or the stack’s template layer).
- **Next.js / Nuxt / other** — follow that framework’s page/router conventions if clearly present.

If signals conflict or the workspace is not a web app repo, **ask the user** which deliverable they want (Vue SFC, Blade, static HTML outline, markdown structure-only, etc.) before implementing.

### New page: add the route when applicable

When the task is a **new user-facing page** and the project uses explicit routes (typical Laravel `routes/web.php` or split route files), **add the route** in the same style as existing entries (path, name, middleware, `Inertia::render` / `view()` / closure return), unless the user forbids touching routes.

After you add or change a route:

1. Tell the user **in the reply** that you registered a route (file + line or route name is enough).
2. Give the **full URL** they can open: read **`APP_URL`** from the project’s `.env` when present; strip a trailing slash; append the route path. Example shape: `https://example.test/new-page` (never invent a domain—use the real `APP_URL` host, or `http://127.0.0.1:8000` if that is what `.env` says).
3. If `APP_URL` is missing, placeholder, or you are unsure which base applies (Forge vs Herd vs Docker), state the **path** (`/new-page`) and ask them to confirm the base URL, or show the pattern: `{APP_URL from your .env}/new-page`.

If routing is ambiguous (multiple route files, locale prefixes, Ziggy-only SPA, API vs web), **do not guess**—ask where to register the route and which path prefix to use.

### Inertia Vue (only when the repo is Inertia + Vue)

- Prefer `resources/js/Pages/…` and `<script setup lang="ts">` when the project uses TypeScript; otherwise match sibling pages.
- Semantic regions: `header`, `nav` (mobile panel), `main`, `footer` as appropriate.
- Do **not** add Inertia `<Head>` unless the user asks for a title stub.

## Before planning (do not guess)

Ask the user questions relevant to page(s) they have asked you to create. Use the **AskQuestion** tool with clear 2–4 options per question. If `AskQuestion` is unavailable, ask the same items in chat with numbered options.

## Acceptance checklist (agent self-check)

- [ ] Only `bg-neutral-500` and `text-neutral-300` / `border-neutral-300` (no extra background grays).
- [ ] Styling is Tailwind-first; any custom CSS lives only in that page’s file (`scoped` / local `<style>`), not global stylesheets.
- [ ] Core regions/controls are named, carry stable `id`s, and visible modules show name/id in their in-block heading where a heading makes sense.
- [ ] If a URL/screenshot was given: layout/UX tracks the reference closely; palette, borders, and no-reference-visuals rules still apply (no borrowed colors/fonts/icons).
- [ ] Sections distinguished by borders (and whitespace), not by background color steps; image/media slots use **dashed** borders, structural blocks use **solid** borders.
- [ ] Mobile: single column; hamburger top-right; menu panel shows full nav, right-aligned links.
- [ ] From `lg:` up: desktop layout and horizontal nav as specified for the page.
- [ ] Outer content centered with `max-w-* mx-auto` on large screens.
- [ ] “Before planning” questions asked (or user explicitly waived) before building landing/pricing-style pages.
- [ ] Deliverable matches repo stack (or user was asked when unclear); new routes announced with resolvable full URL or explicit `{APP_URL}/path` + path.

## Out of scope

Real copy, brand assets, charts, animations beyond basic menu open/close, theme switching, and any visual treatment beyond the two-grayscale wireframe contract.
