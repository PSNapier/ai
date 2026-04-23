---
name: frontend-implementation
description: >-
     Apply our best practices to this repo's design system: 3-5 colors, 2 font families,
     mobile-first Tailwind, tokens in app.css, no blob/emoji slop, SEO via Inertia Head + root
     Blade, WCAG focus/labels, prefers-reduced-motion, Laravel+Inertia form states. Triggers on
     user-facing UI: Vue, React, Inertia, Blade, Tailwind/CSS/SCSS, layout, pages, components,
     design polish, accessibility, or any mention of frontend, styling, or UI. Open this skill
     and follow its Implementation Guidelines at the start of any frontend change.
---

# Frontend site implementation

Follow the **Implementation Guidelines** below for every new feature, refactor, or visual fix when the work is non-trivial.

1. Work through sections in order: color & type → layout/Tailwind/tokens → visuals → SEO → a11y → motion → forms.
2. If the user overrides a rule, comply and note the tradeoff (e.g. SEO, contrast).
3. Tuned for **Laravel + Inertia + Vue**; same product constraints apply to Blade-only or other view layers.

## Color System

ALWAYS use exactly 3-5 colors total.

**Required Color Structure:**

- Choose 1 primary brand color, appropriate for the requested design
- Add 2-3 neutrals (white, grays, off-whites, black variants) and 1-2 accents
- NEVER exceed 5 total colors without explicit user permission
- NEVER use purple or violet prominently, unless explicitly asked for
- If you change a component's background, set matching foreground/text so contrast stays acceptable

**Gradient Rules:**

- Avoid gradients entirely unless explicitly asked for. Use solid colors.
- If gradients are necessary:
     - Use them only as subtle accents, never for primary elements
     - Use analogous colors for gradient: blue→teal, purple→pink, orange→red
     - NEVER mix opposing temperatures: pink→green, orange→blue, red→cyan, etc.
     - Maximum 2-3 color stops, no complex gradients

## Typography

ALWAYS limit to maximum 2 font families total. More fonts create visual chaos and slow loading.

**Required Font Structure:**

- One font for headings (can use multiple weights) and one font for body text

**Typography Implementation Rules:**

- Use line-height between 1.4-1.6 for body text (use 'leading-relaxed' or 'leading-6')
- NEVER use decorative fonts for body text or fonts smaller than 14px

## Tailwind Implementation

ALWAYS mobile-first, then enhance with `md:` / `lg:` breakpoints.

Use these specific Tailwind patterns. Follow this hierarchy for layout decisions.

**Layout Method Priority (use in this order):**

1. Flexbox for most layouts: `flex items-center justify-between`
2. CSS Grid only for complex 2D layouts: e.g. `grid grid-cols-3 gap-4`
3. NEVER use floats or absolute positioning unless absolutely necessary

**Required Tailwind Patterns:**

- Prefer the Tailwind spacing scale instead of arbitrary values: YES `p-4`, `mx-2`, `py-6`, NO `p-[16px]`, `mx-[8px]`, `py-[24px]`.
- Prefer gap classes for spacing: `gap-4`, `gap-x-2`, `gap-y-6`
- Apply fonts via the `font-sans`, `font-serif` and `font-mono` classes in your code
- Use semantic design tokens when possible (bg-background, text-foreground, etc.)
- Wrap titles and other important copy in `text-balance` or `text-pretty` to ensure optimal line breaks
- NEVER mix margin/padding with gap classes on the same element
- NEVER use space-\* classes for spacing

**Semantic Design Token Generation**

Define all applicable tokens in `app.css`. Add new tokens when a design brief needs them.

## Visual Elements & Icons

**Visual Content Rules:**

- NEVER generate abstract shapes like gradient circles, blurry squares, or decorative blobs as filler elements
- NEVER create SVGs directly for complex illustrations or decorative elements
- NEVER hand-draw SVG paths for geographic maps, state/country boundaries, or cartographic data.
- NEVER use emojis as icons

**Icon Implementation:**

- Use the project's existing icons when present; typical sizes 16px, 20px, or 24px

## SEO Requirements

ALWAYS implement SEO best practices automatically for every page/component.

- **Inertia + Vue**: Per-route `title`, `meta` (incl. `og:*`), `link` (canonical), and JSON-LD go in `Head` from `@inertiajs/vue3` (layout or page); pass values via `Inertia::render` props. Keep charset, `viewport`, and shell-only defaults in the **root Blade** once—do not duplicate per page.
- **Title tags**: Include main keyword, keep under 60 characters
- **Meta description**: Max 160 characters with target keyword naturally integrated
- **Single H1**: One per page; match primary intent; include main keyword naturally
- **Semantic HTML**: Use `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<footer>` instead of unlabeled `div` soup
- **Image optimization**: All images must have descriptive alt attributes with relevant keywords
- **Structured data**: Add JSON-LD for products, articles, FAQs when applicable
- **Performance**: Implement lazy loading for images, defer non-critical scripts
- **Clean URLs**: Use descriptive, crawlable internal links (prefer Ziggy / named `route()` in Vue for internal links)

## Accessibility

- Visible **focus** styles on interactive elements; do not `outline: none` without a replacement
- **Labels**: Every control has a visible label or `aria-label` / `aria-labelledby` where a visible label is impossible
- **Dialogs & skip link**: Correct `aria` and dismiss patterns on overlays; **one** “skip to main content” link at the top of the page
- **Contrast**: meet WCAG for text and informative UI

## Motion

- Respect **`prefers-reduced-motion`**: static or low-motion alternative; keep animation subtle. Essential feedback must not depend on motion alone.

## Forms (Laravel + Inertia)

- Design for **error**, **success**, **disabled**, and **loading** states on every submit path
- Surface validation from the backend: Inertia **shared errors** and/or **`useForm`** errors next to fields; do not only rely on `alert()` or generic toasts
- Use Laravel conventions where the stack provides them (e.g. `old()` only when using Blade; with Inertia, prefer re-rendered props + form component state)
