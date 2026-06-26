# Scuffed Corporation — "Mono Bold" Redesign (Design Spec)

**Date:** 2026-06-25
**Status:** Approved direction, ready for implementation planning
**Scope:** Whole-site visual redesign (home, about, projects, privacy, 404) + shared header/footer

## Goal

Replace the current bare/minimal-HTML aesthetic with a confident, premium "Mono Bold"
design system — without losing the site's writing or its jokes. The copy is the asset;
this is a re-skin, not a rewrite.

## Background

The existing site is hand-written static HTML driven by a single `styles.css`, served as-is
(GitHub Pages / Caddy), with no framework, no build, and no JavaScript. The owner likes the
text and the humor but not the "minimal-only HTML" look. Four premium directions were
mocked up; **Mono Bold (light)** was chosen, with one adjustment: the page title is **solid
black**, not set in an acid-lime slab.

## Design direction: Mono Bold (light)

A high-contrast editorial/design-studio look: cream paper, near-black ink, one acid-lime
accent. Big, tight-tracked sans display type; monospace for labels, indices, and badges
(this preserves the engineering soul of today's all-mono site); sans for body. Hard 1px
grid, square corners, strong horizontal rules.

### The lime rule (load-bearing)

Acid-lime (`#d6ff3f`) is **only ever** used as (a) a solid fill behind near-black text, or
(b) a bold graphic element (dot, tick, bar, chip). It is **never** used as text on the cream
background, and never as a thin hairline on cream. This is what keeps everything legible —
it's the lesson from the title-contrast fix. The page title is solid ink; lime never touches it.

## Tokens

| Token | Light | Dark (`prefers-color-scheme: dark`) |
|-------|-------|------|
| `--paper` (bg) | `#f4f3ee` | `#0e0e0e` |
| `--ink` (text, hairlines) | `#0e0e0e` | `#f4f3ee` |
| `--acid` (accent) | `#d6ff3f` | `#d6ff3f` |
| `--muted` (secondary text) | `#5a5a54` | `#a3a39a` |
| `--line-soft` | `rgba(14,14,14,.16)` | `rgba(244,243,238,.18)` |

Dark mode is the inverted treatment (near-black page, off-white text, same lime). Title stays
solid (off-white) in dark — still no lime on the title. All text pairs must meet WCAG AA
(≥ 4.5:1 normal, ≥ 3:1 large). Lime-as-text is only allowed on a near-black fill (e.g. inside
a dark chip or the terminal panel), where it is high-contrast in both modes.

## Typography

- **Display / headings (`h1`, `.page-title`, `h2`, `.deck`):** system grotesk
  (`ui-sans-serif, -apple-system, "SF Pro Display", "Helvetica Neue", Arial`), weight 700,
  tracking ≈ `-0.04em`, solid ink. Case as written (not forced uppercase).
- **Labels / eyebrows / section indices / badges / `h3` / table heads / `dt`:** monospace
  (`ui-monospace, "SF Mono", Menlo`), uppercase, letter-spaced.
- **Body:** system sans, weight 400, `line-height ≈ 1.55`.

## Components

Re-skin the existing component set (class names preserved so markup mostly maps), plus one new
component:

- **Header / nav:** brand (with lime dot) on the left; nav links + a lime "Explore Scuffed OS"
  CTA on the right. Topline reworked to drop the `no javascript` meta-brag.
- **Hero:** solid black title, monospace eyebrow with an index, lime highlight on one word of
  the deck, primary lime CTA + ghost secondary, chips (one lime).
- **Stat strip (NEW, `.stats` / `.stat-band`):** a hard-grid row of four stats carrying the
  jokes (`1 engineer · 0 meetings / week · 0 stock photos of teams pointing at whiteboards ·
  1 product in daily production`). This becomes the site's primary joke-carrier now that the
  colophon brag is retired.
- **Sections (`.sec` / `.sec-label` / `.note`):** numbered monospace section labels, solid
  hairline rules, lime-barred margin notes.
- **Facts tables (`.facts`):** hard 1px ink grid, monospace heads.
- **Modules grid + status tags (`.modules`, `.tag-live/-dev/-plan`):** card grid; `live` =
  lime fill / black text, `dev` = ink outline, `planned` = dashed muted.
- **Meta list (`.meta`):** monospace terms, hairline rows.
- **Terminal blocks (`.term`):** rendered as a true dark inset panel (near-black, off-white,
  lime prompt/markers) in both modes — fits the existing `~ ❯ scuffedos status` content.
- **Buttons (`.btn`):** square; primary lime/black, secondary ink-outline ghost.
- **Footer:** colophon reworked (see Copy changes); contact + copyright kept.

## Pages

All five pages adopt the system. Only the homepage and the shared chrome need markup changes;
the interior pages (about, projects, privacy, 404) re-skin automatically through the shared
stylesheet + chrome edits.

- **Home:** new hero markup + the new stat strip; existing "what we do" facts and the Scuffed
  OS flagship (modules / terminal / meta) re-skin via CSS.
- **About / Projects / Privacy / 404:** chrome edits only; content re-skins via CSS. All
  margin-note jokes and product jokes preserved.

## Copy changes (surgical — everything else verbatim)

Only the **site-tech meta-jokes** are retired; **all product/brand jokes stay**.

- **Topline** (`no trackers · no cookies · no javascript`) → reworked to a non-meta,
  brand-flavored line, e.g. `self-hosted · one engineer · est. 2026`.
- **Footer colophon** (`This site is handwritten HTML and CSS … no JavaScript … nothing to
  load`) → reworked to lean on honesty/product voice and privacy (still true: no trackers, no
  cookies), dropping the handwritten-HTML / no-JS / nothing-to-load brag. The privacy-policy
  pointer line is kept.
- **Kept verbatim:** the stat-strip jokes, `rough around the edges · solid through the middle`,
  `status: shipping · 1 engineer · 100% real software`, the `scuff` definition note, the
  vaporware-policy note, `// this cell intentionally left scuffed`, and all other body copy.

## Accessibility & constraints (held constant)

- Skip link, semantic HTML, ARIA labels, `.visually-hidden`, visible `:focus-visible` ring
  (solid ink, high-contrast in both modes), 320px reflow (WCAG 1.4.10), `prefers-reduced-motion`
  (disables hover transforms), and per-mode `theme-color` (updated to `#f4f3ee` / `#0e0e0e`).
- **Unchanged platform rules:** static hand-written HTML, exactly one `styles.css`, system
  fonts only, no framework, no build step, **no JavaScript**. (So every retired joke remains
  literally true — we just stop bragging about it.)
- All text ≥ WCAG AA; lime never used as text on the cream background.

## Out of scope

- Any new pages, sections, or substantive copy beyond the meta-joke rework.
- Any backend, form, analytics, or JavaScript.
- A favicon redesign is optional polish (a small palette refresh only), not a requirement.

## Success criteria

1. All five pages render in the Mono Bold system, visually consistent through the shared
   stylesheet.
2. The page title is unmistakably legible on every page, in light and dark mode.
3. Every product/brand joke is preserved; only the site-tech meta-jokes are gone.
4. No `<script>` anywhere; still one `styles.css`, system fonts, no build.
5. WCAG AA contrast holds for all text pairs in both modes; layout reflows cleanly at 320px.
