# Mono Bold Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-skin the whole static site (home, about, projects, privacy, 404) into the "Mono Bold" design system without changing any copy except the retired site-tech meta-jokes.

**Architecture:** One shared `styles.css` is rewritten to the new system using the existing class names, so most pages re-skin automatically. Only the shared header/footer chrome and the homepage hero need HTML edits. No framework, no build, no JavaScript — same as today.

**Tech Stack:** Hand-written HTML5 + a single CSS file. System fonts. Served statically (GitHub Pages / Caddy). Verification via `python3 -m http.server` + browser screenshots + grep/contrast checks.

**Design reference:** `docs/superpowers/specs/2026-06-25-mono-bold-redesign-design.md`

## Global Constraints

Every task must honor these (copied from the spec):

- Exactly **one** stylesheet: `styles.css`. No second CSS file, no `<style>` blocks in HTML.
- **No JavaScript.** No `<script>` tags anywhere. No framework, no build step.
- **System fonts only** — no web-font `<link>`/`@import`, no external network requests.
- Tokens — light: `--paper:#f4f3ee`, `--ink:#0e0e0e`, `--acid:#d6ff3f`, `--muted:#5a5a54`.
  Dark (`prefers-color-scheme: dark`): `--paper:#0e0e0e`, `--ink:#f4f3ee`, `--acid:#d6ff3f`, `--muted:#a3a39a`.
- **The lime rule:** `#d6ff3f` is only ever a fill behind near-black text or a bold graphic
  element (dot/tick/bar/chip). Never text on cream; never a hairline on cream.
- Preserve all product/brand jokes verbatim. Retire only the site-tech meta-jokes (topline
  `no javascript`; footer `handwritten HTML … no JavaScript … nothing to load`).
- Preserve accessibility: skip link, ARIA, `.visually-hidden`, `:focus-visible`, 320px reflow,
  `prefers-reduced-motion`, per-mode `theme-color` (`#f4f3ee` light / `#0e0e0e` dark).
- All text pairs meet WCAG AA in both modes.

## File Structure

| File | Responsibility | Change |
|------|----------------|--------|
| `styles.css` | The entire Mono Bold design system | **Rewrite** |
| `index.html` | Home: hero + new stat strip; flagship re-skins via CSS | Chrome + hero edits |
| `about/index.html` | About page | Chrome edits only |
| `projects/index.html` | Projects page | Chrome edits only |
| `privacy/index.html` | Privacy policy (long-form) | Chrome edits only |
| `404.html` | Not-found page | Chrome edits only |
| `favicon.svg` | Site mark | Optional palette refresh (Task 4) |

"Chrome edits" = the shared `<header>` (topline + nav) markup, the footer colophon copy, and
the `theme-color` meta tags. The chrome markup is identical on every page except the
`aria-current="page"` link and the `<title>`/canonical (unchanged).

---

### Task 1: Rewrite `styles.css` as the Mono Bold design system

**Files:**
- Modify (full rewrite): `styles.css`

**Interfaces:**
- Produces these classes the HTML relies on (names kept from the old stylesheet unless marked NEW):
  `.frame`, `.skip`, `.visually-hidden`, `.topline`, `.site-nav`, `.brand`, `.nav-right` (NEW),
  `.nav-cta` (NEW), `.sec`, `.sec-label`, `.note`, `.hero`, `.eyebrow` (NEW), `.deck`, `.chips`,
  `.lede`, `.cta-row` (NEW), `.stat-band` (NEW), `.stats` (NEW), `.stat-num` (NEW),
  `.stat-label` (NEW), `.page-title`, `.sub`, `.facts`, `.facts--auto`, `.table-scroll`,
  `.modules`, `.mod-name`, `.mod-desc`, `.tag`, `.tag-live`, `.tag-dev`, `.tag-plan`, `.legend`,
  `.meta`, `.term`, `.term-prompt`, `.term-ok`, `.term-dev`, `.term-cmt`, `.btn`, `.btn-ghost`
  (NEW), `.colophon`, `.copyright`, `.promptline`, `.muted`.

- [ ] **Step 1: Replace the entire contents of `styles.css` with the design system below**

```css
/* ============================================================
   Scuffed Corporation — styles.css
   "Mono Bold" design system. One stylesheet, system fonts,
   no frameworks, no JavaScript. Light + dark.
   ------------------------------------------------------------
   00 tokens   01 base   02 skip + utilities   03 frame
   04 topline + nav   05 sections + notes   06 display + hero
   07 stat strip   08 prose   09 tables   10 modules + tags
   11 meta list   12 terminal   13 button   14 footer
   ============================================================ */

/* ---------- 00 tokens ---------- */
:root {
  --paper: #f4f3ee;
  --ink: #0e0e0e;
  --acid: #d6ff3f;
  --muted: #5a5a54;
  --line-soft: rgba(14, 14, 14, .16);
  --sans: ui-sans-serif, -apple-system, "SF Pro Display", "Helvetica Neue", Arial, sans-serif;
  --mono: ui-monospace, "SF Mono", SFMono-Regular, Menlo, Consolas, monospace;
  --pad: clamp(16px, 4vw, 40px);
  --maxw: 1100px;
}
@media (prefers-color-scheme: dark) {
  :root {
    --paper: #0e0e0e;
    --ink: #f4f3ee;
    --muted: #a3a39a;
    --line-soft: rgba(244, 243, 238, .18);
  }
}

/* ---------- 01 base ---------- */
* { box-sizing: border-box; }
html { -webkit-text-size-adjust: 100%; }
body {
  margin: 0;
  background: var(--paper);
  color: var(--ink);
  font-family: var(--sans);
  font-size: 16px;
  line-height: 1.55;
  -webkit-font-smoothing: antialiased;
}
img, svg { max-width: 100%; height: auto; }
::selection { background: var(--acid); color: #0e0e0e; }
:focus-visible { outline: 3px solid var(--ink); outline-offset: 2px; }
a { color: inherit; text-decoration: underline; text-decoration-thickness: 2px; text-underline-offset: 3px; }
a:hover { background: var(--acid); color: #0e0e0e; text-decoration: none; }
a[href^="mailto:"] { overflow-wrap: anywhere; }
p { margin: 0 0 1.1rem; }

/* ---------- 02 skip + utilities ---------- */
.skip {
  position: absolute; left: -999px; top: 0;
  background: var(--ink); color: var(--paper);
  padding: .6rem 1rem; z-index: 10; text-decoration: none;
}
.skip:focus { left: var(--pad); }
.visually-hidden {
  position: absolute; width: 1px; height: 1px;
  margin: -1px; padding: 0; border: 0;
  clip: rect(0 0 0 0); clip-path: inset(50%); overflow: hidden; white-space: nowrap;
}
.muted { color: var(--muted); }

/* ---------- 03 frame ---------- */
.frame {
  max-width: var(--maxw); margin: 0 auto;
  border-inline: 1px solid var(--ink);
  min-height: 100vh; display: flex; flex-direction: column;
}
main { flex: 1; }

/* ---------- 04 topline + nav ---------- */
.topline {
  display: flex; flex-wrap: wrap; gap: .25rem 1.5rem; justify-content: space-between;
  font-family: var(--mono); font-size: 11px; letter-spacing: .14em; text-transform: uppercase;
  color: var(--muted); padding: .5rem var(--pad); border-bottom: 1px solid var(--ink); margin: 0;
}
.site-nav {
  display: flex; flex-wrap: wrap; gap: .75rem 1.25rem;
  align-items: center; justify-content: space-between;
  padding: .85rem var(--pad); border-bottom: 1px solid var(--ink);
}
.brand {
  display: inline-flex; align-items: center; gap: .55rem;
  font-weight: 700; font-size: 15px; letter-spacing: -.01em; text-decoration: none;
}
.brand::before {
  content: ""; width: 11px; height: 11px; border-radius: 50%;
  background: var(--acid); border: 1.5px solid var(--ink); flex: none;
}
.brand:hover { background: none; color: inherit; }
.nav-right { display: flex; align-items: center; gap: 1rem 1.25rem; flex-wrap: wrap; }
.site-nav ul {
  list-style: none; margin: 0; padding: 0;
  display: flex; flex-wrap: wrap; gap: .4rem 1.1rem; align-items: center;
  font-family: var(--mono); font-size: 11px; letter-spacing: .08em; text-transform: uppercase;
}
.site-nav li { margin: 0; }
.site-nav ul a { color: var(--muted); text-decoration: none; }
.site-nav ul a:hover { background: none; color: var(--ink); }
.site-nav a[aria-current="page"] { color: var(--ink); font-weight: 700; }
.nav-cta {
  display: inline-flex; align-items: center; gap: .4rem;
  font-family: var(--sans); font-size: 12px; font-weight: 700; letter-spacing: .02em; text-transform: none;
  padding: .5rem .8rem; background: var(--acid); color: #0e0e0e; border: 1.5px solid var(--ink); text-decoration: none;
}
.nav-cta:hover { background: #0e0e0e; color: var(--acid); }

/* ---------- 05 sections + notes ---------- */
.sec {
  border-bottom: 1px solid var(--ink);
  padding: clamp(2rem, 6vw, 4rem) var(--pad);
  display: grid; grid-template-columns: minmax(0, 1fr); gap: 1.4rem 3.5rem; align-items: start;
}
.sec-main { max-width: 68ch; min-width: 0; }
.sec-main > :last-child { margin-bottom: 0; }
.sec-label {
  grid-column: 1 / -1;
  display: flex; flex-wrap: wrap; justify-content: space-between; gap: .15rem 1rem; margin: 0 0 .25rem;
  font-family: var(--mono); font-size: 11px; letter-spacing: .16em; text-transform: uppercase; color: var(--muted);
  border-bottom: 1px solid var(--line-soft); padding-bottom: .5rem;
}
.sec-label span { white-space: nowrap; }
.note {
  font-family: var(--mono); font-size: 12px; line-height: 1.6; color: var(--muted);
  border-left: 3px solid var(--acid); padding-left: .9rem; max-width: 40ch;
}
.note strong { color: var(--ink); }
@media (min-width: 980px) {
  .sec { grid-template-columns: minmax(0, 68ch) minmax(200px, 1fr); }
  .note { position: sticky; top: 1.5rem; justify-self: end; }
}

/* ---------- 06 display + hero ---------- */
.hero { padding-top: clamp(1.5rem, 4vw, 3rem); }
h1, .page-title {
  font-weight: 700; letter-spacing: -.04em; line-height: .92; color: var(--ink);
  margin: .4rem 0 1.1rem; font-size: clamp(2.4rem, 8vw, 4.5rem);
}
.page-title { font-size: clamp(2.2rem, 7vw, 4rem); }
.hero h1 { font-size: clamp(2.8rem, 11vw, 7rem); }
.eyebrow {
  display: inline-flex; align-items: center; gap: .6rem; margin: 0 0 .35rem;
  font-family: var(--mono); font-size: 11px; font-weight: 600; letter-spacing: .14em; text-transform: uppercase; color: var(--ink);
}
.eyebrow .ar { font-size: 1.1em; }
h2 { font-weight: 700; font-size: clamp(1.6rem, 5vw, 2.6rem); line-height: 1; letter-spacing: -.03em; margin: .3rem 0 1rem; }
h3 { font-family: var(--mono); font-size: 13px; text-transform: uppercase; letter-spacing: .1em; margin: 1.9rem 0 .65rem; color: var(--ink); }
.sub { font-weight: 700; font-size: clamp(1.05rem, 2.4vw, 1.3rem); margin: 0 0 1rem; }
.deck {
  font-size: clamp(1.25rem, 3.4vw, 2rem); font-weight: 700; letter-spacing: -.02em; line-height: 1.08;
  margin: .6rem 0 1rem; max-width: 24ch;
}
.deck u, .hl {
  text-decoration: none; background: var(--acid); color: #0e0e0e;
  box-decoration-break: clone; -webkit-box-decoration-break: clone; padding: 0 .12em;
}
.chips {
  margin: 0 0 1.4rem; padding: 0; list-style: none;
  display: flex; flex-wrap: wrap; gap: .45rem .55rem;
  font-family: var(--mono); font-size: 11px; letter-spacing: .06em; text-transform: uppercase;
}
.chips li { border: 1px solid var(--line-soft); padding: .4em .8em; border-radius: 100px; margin: 0; }
.chips li:nth-child(2) { background: var(--acid); color: #0e0e0e; border-color: var(--ink); }
.lede { font-size: clamp(1rem, 2vw, 1.15rem); color: var(--muted); max-width: 60ch; margin: 0 0 1.1rem; }
.lede strong, .lede b { color: var(--ink); }
.cta-row { display: flex; flex-wrap: wrap; gap: .7rem; align-items: center; margin: 1.6rem 0 1.4rem; }

/* ---------- 07 stat strip ---------- */
.stat-band { border-bottom: 1px solid var(--ink); padding: clamp(1.25rem, 4vw, 2.25rem) var(--pad); }
.stat-band .stats { margin: 0; }
.stats {
  list-style: none; padding: 0; margin: 1.75rem 0;
  display: grid; grid-template-columns: repeat(4, 1fr);
  border: 1px solid var(--ink); background: var(--ink); gap: 1px;
}
.stats li {
  background: var(--paper); padding: 1.1rem 1rem; margin: 0; min-height: 7rem;
  display: flex; flex-direction: column; justify-content: space-between;
}
.stat-num { font-size: clamp(2.2rem, 6vw, 3.6rem); font-weight: 700; letter-spacing: -.04em; line-height: .85; }
.stat-num .em { border-bottom: .1em solid var(--acid); }
.stat-label {
  font-family: var(--mono); font-size: 11px; font-weight: 600; letter-spacing: .1em; text-transform: uppercase;
  color: var(--muted); line-height: 1.35; margin-top: .7rem;
}
@media (max-width: 640px) { .stats { grid-template-columns: repeat(2, 1fr); } }

/* ---------- 08 prose ---------- */
:where(.sec-main) ul, :where(.sec-main) ol { margin: 0 0 1.1rem; padding-left: 1.35rem; }
:where(.sec-main) li { margin: 0 0 .4rem; }
:where(.sec-main) li::marker { color: var(--muted); }
blockquote { margin: 1.5rem 0; padding: .2rem 0 .2rem 1rem; border-left: 3px solid var(--acid); }
hr { border: 0; border-top: 1px solid var(--line-soft); margin: 2rem 0; }
code { font-family: var(--mono); border: 1px solid var(--line-soft); padding: .05em .35em; font-size: .9em; }
pre code { border: 0; padding: 0; font-size: inherit; }
.promptline { font-family: var(--mono); font-size: 13px; color: var(--muted); margin: 0 0 .85rem; }
.promptline b, .promptline .ps { color: var(--ink); font-weight: 700; }

/* ---------- 09 tables ---------- */
table.facts { width: 100%; border-collapse: collapse; margin: 1.75rem 0; font-size: 14px; }
.facts th, .facts td { border: 1px solid var(--ink); padding: .6rem .85rem; text-align: left; vertical-align: top; }
.facts th { width: 46%; font-weight: 700; }
.facts td { color: var(--muted); }
.facts td strong, .facts th strong { color: var(--ink); }
.facts td a, .facts th a { color: var(--ink); }
.facts thead th {
  width: auto; font-family: var(--mono); font-size: 11px; letter-spacing: .12em; text-transform: uppercase; color: var(--muted);
}
.facts--auto th { width: auto; }
.table-scroll { overflow-x: auto; margin: 1.75rem 0; }
.table-scroll > table { margin: 0; }

/* ---------- 10 modules + tags ---------- */
.modules {
  list-style: none; margin: 1.75rem 0; padding: 0;
  display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 1px; background: var(--ink); border: 1px solid var(--ink);
}
.modules li {
  background: var(--paper); padding: .95rem .95rem 1rem; margin: 0;
  display: flex; flex-direction: column; gap: .35rem; min-height: 7.5rem;
}
.mod-name { font-weight: 700; font-size: 14px; letter-spacing: -.01em; }
.mod-desc { font-family: var(--mono); font-size: 11.5px; color: var(--muted); line-height: 1.5; }
.tag {
  margin-top: auto; align-self: flex-start;
  display: inline-flex; align-items: center; gap: .4em;
  font-family: var(--mono); font-size: 10px; font-weight: 700; letter-spacing: .1em; text-transform: uppercase;
  padding: .3em .6em; border: 1.5px solid var(--ink); border-radius: 100px;
}
.tag::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.tag-live { background: var(--acid); color: #0e0e0e; border-color: var(--ink); }
.tag-live::before { background: #0e0e0e; }
.tag-dev { background: transparent; color: var(--ink); border-color: var(--ink); }
.tag-plan { background: transparent; color: var(--muted); border: 1.5px dashed var(--line-soft); }
.legend { font-family: var(--mono); font-size: 11px; color: var(--muted); margin: -0.75rem 0 1.75rem; }

/* ---------- 11 meta list ---------- */
dl.meta { margin: 0 0 2rem; font-size: 14px; }
.meta > div {
  display: grid; grid-template-columns: 8rem minmax(0, 1fr); gap: 1rem;
  padding: .6rem 0; border-top: 1px solid var(--line-soft);
}
.meta > div:last-child { border-bottom: 1px solid var(--line-soft); }
.meta dt { font-family: var(--mono); text-transform: uppercase; letter-spacing: .1em; font-size: 11px; color: var(--muted); padding-top: .15em; }
.meta dd { margin: 0; }
.meta dd a { color: var(--ink); }
@media (max-width: 480px) { .meta > div { grid-template-columns: 1fr; gap: .15rem; } }

/* ---------- 12 terminal (always a dark inset panel) ---------- */
.term {
  margin: 1.75rem 0; padding: 1rem 1.15rem; border: 1px solid #2a2a2a;
  background: #121212; color: #e9e7df;
  font-family: var(--mono); font-size: 13px; line-height: 1.8; overflow-x: auto;
}
.term p { margin: 0; }
pre.term { white-space: pre; line-height: 1.7; }
.term a { color: #e9e7df; }
.term a:hover { background: var(--acid); color: #0e0e0e; }
.term-prompt { color: #8a8a82; }
.term-ok { color: var(--acid); font-weight: 700; }
.term-dev { color: var(--acid); font-weight: 700; }
.term-cmt { color: #8a8a82; }

/* ---------- 13 button ---------- */
.btn {
  display: inline-flex; align-items: center; gap: .5rem;
  font-family: var(--sans); font-weight: 700; font-size: 14px; letter-spacing: .01em;
  padding: .75rem 1.2rem; border: 1.5px solid var(--ink); background: var(--acid); color: #0e0e0e;
  text-decoration: none; transition: transform .12s ease;
}
.btn:hover { background: #0e0e0e; color: var(--acid); transform: translateY(-2px); }
.btn:active { transform: translateY(0); }
.btn-ghost { background: transparent; color: var(--ink); }
.btn-ghost:hover { background: var(--ink); color: var(--paper); }
@media (prefers-reduced-motion: reduce) { .btn { transition: none; } }

/* ---------- 14 footer ---------- */
footer {
  border-top: 1px solid var(--ink); padding: 2rem var(--pad) 2.5rem; font-size: 14px;
  display: grid; grid-template-columns: minmax(0, 1fr); gap: 1.5rem 3rem;
}
@media (min-width: 760px) { footer { grid-template-columns: 1fr 1fr; } }
footer h2 { font-family: var(--mono); font-size: 11px; letter-spacing: .16em; text-transform: uppercase; color: var(--muted); margin: 0 0 .6rem; }
footer p { margin: 0 0 .5rem; }
.colophon { color: var(--muted); }
.colophon a { color: var(--ink); }
.copyright {
  grid-column: 1 / -1; border-top: 1px solid var(--line-soft); padding-top: 1rem;
  font-family: var(--mono); font-size: 11px; letter-spacing: .1em; text-transform: uppercase; color: var(--muted);
  display: flex; flex-wrap: wrap; gap: .5rem 2rem; justify-content: space-between;
}
```

- [ ] **Step 2: Serve the site locally and screenshot the homepage**

Run: `python3 -m http.server 8000` (from the repo root; leave it running).
Open `http://localhost:8000/` and screenshot it (use the browser-preview / run tooling).
Expected: the homepage renders with the new palette (cream bg, black type) — it will still
have the old hero markup (the squiggle title, no stat strip); that's fixed in Task 3. The
point of this step is to confirm the stylesheet loads and the new tokens, nav, sections,
modules, terminal, and footer all render without layout breakage.

- [ ] **Step 3: Run the automated stylesheet checks**

Run:
```bash
grep -c "#d6ff3f" styles.css        # accent present (expect >= 1)
grep -c "prefers-color-scheme: dark" styles.css   # dark mode present (expect 1)
grep -c "prefers-reduced-motion" styles.css       # reduced motion present (expect 1)
grep -ci "f5f2ea\|141312" styles.css              # old tokens gone (expect 0)
```
Expected: first three > 0, the last is `0`.

- [ ] **Step 4: Run the contrast check (light + dark pairs)**

Run:
```bash
python3 - <<'PY'
def lum(h):
    r,g,b=[int(h[i:i+2],16)/255 for i in (1,3,5)]
    f=lambda c: c/12.92 if c<=0.03928 else ((c+0.055)/1.055)**2.4
    R,G,B=f(r),f(g),f(b); return 0.2126*R+0.7152*G+0.0722*B
def ratio(a,b):
    L=sorted([lum(a),lum(b)],reverse=True); return (L[0]+0.05)/(L[1]+0.05)
pairs=[("#0e0e0e","#f4f3ee","light ink/paper",4.5),
       ("#5a5a54","#f4f3ee","light muted/paper",4.5),
       ("#0e0e0e","#d6ff3f","black on lime (btn/chip)",4.5),
       ("#d6ff3f","#121212","lime on terminal",4.5),
       ("#f4f3ee","#0e0e0e","dark ink/paper",4.5),
       ("#a3a39a","#0e0e0e","dark muted/paper",4.5)]
ok=True
for a,b,n,th in pairs:
    r=ratio(a,b); s="PASS" if r>=th else "FAIL"; ok&=r>=th
    print(f"{s}  {r:5.2f}  {n}")
raise SystemExit(0 if ok else 1)
PY
```
Expected: every line prints `PASS`; exit code `0`.

- [ ] **Step 5: Commit**

```bash
git add styles.css
git commit -m "feat: rewrite styles.css as Mono Bold design system

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 2: Apply shared chrome + metadata to all five pages

Re-skins the header/footer on every page and retires the site-tech meta-jokes. The nav markup
is standardized (the old `index.html` nav had no brand link; some pages lacked the CTA).

**Files:**
- Modify: `index.html`, `about/index.html`, `projects/index.html`, `privacy/index.html`, `404.html`

**Interfaces:**
- Consumes from Task 1: `.brand`, `.nav-right`, `.nav-cta`, `.site-nav a[aria-current]`,
  `.colophon`, `.copyright`.

- [ ] **Step 1: On every page, replace the `<header>…</header>` block with this exact markup**

Set `aria-current="page"` on the link for the current page only (Home on `index.html`, About on
`about/index.html`, etc.). `404.html` gets **no** `aria-current` (it isn't a nav destination).

```html
  <header>
    <p class="topline">
      <span>scuffedcorporation.com</span>
      <span>self-hosted &middot; one engineer &middot; est. 2026</span>
    </p>
    <nav class="site-nav" aria-label="Main">
      <a class="brand" href="/">Scuffed&nbsp;Corporation</a>
      <div class="nav-right">
        <ul>
          <li><a href="/">Home</a></li>
          <li><a href="/about/">About</a></li>
          <li><a href="/projects/">Projects</a></li>
          <li><a href="/privacy/">Privacy</a></li>
        </ul>
        <a class="nav-cta" href="/projects/">Explore Scuffed&nbsp;OS</a>
      </div>
    </nav>
  </header>
```

Example for `about/index.html`: the About `<li>` becomes
`<li><a href="/about/" aria-current="page">About</a></li>`.

- [ ] **Step 2: On every page, replace the footer `.colophon` block with this exact markup**

```html
    <div class="colophon">
      <h2>Colophon</h2>
      <p>One engineer, one stylesheet, one product that actually ships. No trackers, no cookies, nothing here is watching you read it.</p>
      <p>Read the <a href="/privacy/">privacy policy</a> &mdash; this site collects nothing; the policy covers what the Scuffed OS app stores.</p>
    </div>
```

(The old `index.html` and `404.html` colophons differ slightly from the others — replace whatever
`.colophon` block each page has with the markup above so all five match. Leave the sibling
`<div><h2>Contact</h2>…</div>` and the `.copyright` line unchanged.)

- [ ] **Step 3: On every page, update the two `theme-color` meta tags**

Change:
```html
<meta name="theme-color" content="#f5f2ea" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#141312" media="(prefers-color-scheme: dark)">
```
to:
```html
<meta name="theme-color" content="#f4f3ee" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#0e0e0e" media="(prefers-color-scheme: dark)">
```

- [ ] **Step 4: Verify the meta-jokes are gone and the chrome is consistent**

Run:
```bash
grep -rli "no javascript" . --include=*.html          # expect: no output
grep -rli "handwritten HTML" . --include=*.html        # expect: no output
grep -rli "nothing to load" . --include=*.html         # expect: no output
grep -rl "f5f2ea\|141312" . --include=*.html           # expect: no output
grep -rlL "nav-cta" index.html about/index.html projects/index.html privacy/index.html 404.html  # expect: no output (every page HAS nav-cta)
```
Expected: the first four produce no output; the last (files *missing* `nav-cta`) produces no output.

- [ ] **Step 5: Visually verify each page's header and footer**

Serve (`python3 -m http.server 8000`) and screenshot the top and bottom of `/`, `/about/`,
`/projects/`, `/privacy/`, and a 404 (e.g. `http://localhost:8000/nope`).
Expected: identical nav (brand + lime dot, links, lime CTA) and footer colophon on every page;
the active link is bold ink; reworked topline/colophon copy shows; no leftover meta-jokes.

- [ ] **Step 6: Commit**

```bash
git add index.html about/index.html projects/index.html privacy/index.html 404.html
git commit -m "feat: apply Mono Bold chrome + retire site-tech meta-jokes across all pages

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 3: Homepage hero + stat strip

Rebuilds the homepage hero for Mono Bold (solid black title, eyebrow, lime-highlighted deck
word, primary + ghost CTAs) and inserts the new stat strip. The "what we do" and Scuffed OS
flagship sections below need no markup change — they re-skin via Task 1.

**Files:**
- Modify: `index.html` (the hero `<section>` and a new stat-band section after it)

**Interfaces:**
- Consumes from Task 1: `.hero`, `.eyebrow`, `.deck` (+ `u`), `.cta-row`, `.btn`, `.btn-ghost`,
  `.chips`, `.stat-band`, `.stats`, `.stat-num` (+ `.em`), `.stat-label`, `.note`.

- [ ] **Step 1: Replace the hero `<section class="sec hero" …>…</section>` block with this**

(Removes the inline squiggle `<svg>`; keeps the `scuff` definition margin note.)

```html
    <!-- 00 / hero -->
    <section class="sec hero" aria-labelledby="hero-title">
      <p class="sec-label"><span>00 &mdash; home</span><span>self-hosted &middot; one engineer</span></p>
      <div class="sec-main">
        <p class="eyebrow"><span class="ar" aria-hidden="true">&#8600;</span>Self-hosted software, one engineer</p>
        <h1 id="hero-title">Scuffed Corporation</h1>
        <p class="deck">The name is a <u>joke</u>. The software isn&rsquo;t.</p>
        <p class="lede">The home for software built by <strong>Dylan Schempp</strong> &mdash; self-hosted tools and an honest roadmap, built to production standards because the first and most demanding user is the person who wrote it.</p>
        <div class="cta-row">
          <a class="btn" href="/projects/">Explore Scuffed OS &rarr;</a>
          <a class="btn btn-ghost" href="/about/">Read about</a>
        </div>
        <ul class="chips" aria-label="In short">
          <li>one engineer</li>
          <li>self-hosted</li>
          <li>your data stays yours</li>
        </ul>
      </div>
      <aside class="note" aria-label="Margin note">
        <strong>scuff</strong> /sk&#652;f/, <em>v.</em> &mdash; to scrape or wear the surface of something. The surface. Not the structure.
      </aside>
    </section>
```

- [ ] **Step 2: Insert the stat strip immediately after the hero `</section>`**

```html
    <!-- 00b / by the numbers -->
    <section class="stat-band" aria-label="By the numbers">
      <ul class="stats">
        <li><span class="stat-num"><span class="em">1</span></span><span class="stat-label">engineer</span></li>
        <li><span class="stat-num">0</span><span class="stat-label">meetings / week</span></li>
        <li><span class="stat-num">0</span><span class="stat-label">stock photos of teams pointing at whiteboards</span></li>
        <li><span class="stat-num"><span class="em">1</span></span><span class="stat-label">product in daily production</span></li>
      </ul>
    </section>
```

- [ ] **Step 3: Verify the hero markup changed and the squiggle is gone**

Run:
```bash
grep -c "squig" index.html        # expect: 0
grep -c "stat-band" index.html    # expect: 1
grep -c "class=\"eyebrow\"" index.html   # expect: 1
grep -c "<u>joke</u>" index.html  # expect: 1
grep -c "<script" index.html      # expect: 0
```
Expected: `0`, `1`, `1`, `1`, `0`.

- [ ] **Step 4: Visually verify the homepage hero**

Serve and screenshot `http://localhost:8000/`.
Expected: solid black "Scuffed Corporation" title (fully legible), monospace eyebrow with the
`↘`, lime highlight only on the word "joke", a lime primary button + ghost secondary, three
chips (middle one lime), and the four-cell stat strip with the jokes intact. Resize the window
narrow (~360px) and confirm the stat strip drops to 2 columns and nothing overflows.

- [ ] **Step 5: Commit**

```bash
git add index.html
git commit -m "feat: Mono Bold homepage hero + stat strip

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 4: Whole-site verification + favicon refresh

Confirms the interior pages (which only received chrome edits) re-skin correctly, validates the
global constraints across the whole site, and refreshes the favicon to the new palette.

**Files:**
- Modify: `favicon.svg`

- [ ] **Step 1: Refresh `favicon.svg` to the Mono Bold mark**

Replace the file contents with this (cream tile, ink border, lime dot — matches the brand mark):

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" role="img" aria-label="Scuffed Corporation">
  <rect x="1" y="1" width="30" height="30" rx="4" fill="#f4f3ee" stroke="#0e0e0e" stroke-width="2"/>
  <circle cx="16" cy="16" r="6" fill="#d6ff3f" stroke="#0e0e0e" stroke-width="2"/>
</svg>
```

- [ ] **Step 2: Run the whole-site automated gates**

Run:
```bash
grep -rl "<script" . --include=*.html        # no JS anywhere — expect: no output
ls *.css */*.css 2>/dev/null                  # exactly one stylesheet — expect: only "styles.css"
grep -rli "no javascript\|handwritten HTML\|nothing to load" . --include=*.html  # expect: no output
for f in index.html about/index.html projects/index.html privacy/index.html 404.html; do
  grep -q 'href="/styles.css"' "$f" && echo "ok $f" || echo "MISSING stylesheet link: $f"
done
```
Expected: no `<script>` matches; the only CSS file is `styles.css`; no meta-jokes; every page
prints `ok`.

- [ ] **Step 3: Visually verify every page in light and dark mode**

Serve, then screenshot `/`, `/about/`, `/projects/`, `/privacy/`, and `/nope` (404) twice —
once in light mode, once with the OS/browser in dark mode (or emulated `prefers-color-scheme:
dark`).
Confirm for each page:
- Title/headings legible; no lime text on cream anywhere; lime only as fills/dots/ticks/bars.
- Facts tables, module grid + status tags, terminal panels, and meta lists all render in the
  new system; the terminal blocks are dark insets with a lime prompt in both modes.
- Dark mode inverts to near-black/off-white with the same lime; nothing becomes unreadable
  (especially status tags and the nav CTA).
- Margin-note jokes, the `// this cell intentionally left scuffed` cell, and the vaporware-policy
  note are all still present.

- [ ] **Step 4: Verify 320px reflow**

In the browser dev tools, set the viewport to 320px wide and scroll each page.
Expected: no horizontal scrolling of the page; wide tables (privacy service-providers table)
scroll inside their `.table-scroll` wrapper only; the email address wraps; nothing is clipped.

- [ ] **Step 5: Commit**

```bash
git add favicon.svg
git commit -m "chore: refresh favicon to Mono Bold palette; verify whole-site redesign

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Self-Review

**1. Spec coverage**

| Spec item | Task |
|-----------|------|
| Mono Bold tokens (light + dark) | Task 1 §00 |
| The lime rule (fills/graphics only) | Task 1 (tags, chips, deck `u`, stat `.em`, term) + Task 4 §3 visual gate |
| Typography (sans display / mono labels / sans body) | Task 1 §06, §04, §11 |
| Header/nav re-skin + topline rework | Task 1 §04 + Task 2 §1, §4 |
| Hero (solid black title, eyebrow, deck highlight, CTAs, chips) | Task 1 §06 + Task 3 §1 |
| Stat strip (new, joke-carrier) | Task 1 §07 + Task 3 §2 |
| Sections / notes / facts / modules+tags / meta / terminal / buttons | Task 1 §05, §09, §10, §11, §12, §13 |
| Footer colophon rework | Task 2 §2 |
| Copy: retire only site-tech meta-jokes, keep product jokes | Task 2 §1–2, §4 + Task 3 (jokes kept) + Task 4 §2 |
| Accessibility (skip, ARIA, focus, reduced-motion, theme-color, 320px) | Task 1 §01–02, §13; Task 2 §3; Task 4 §4 |
| Constraints (one CSS, no JS, system fonts) | Global Constraints + Task 4 §2 |
| WCAG AA contrast both modes | Task 1 §4 (script) + Task 4 §3 |
| Favicon optional refresh | Task 4 §1 |

No gaps found.

**2. Placeholder scan:** No TBD/TODO/"add error handling"/"similar to Task N". Every code step
shows the full content. ✔

**3. Type/name consistency:** Class names used in Task 2/3 markup (`.brand`, `.nav-right`,
`.nav-cta`, `.eyebrow`, `.cta-row`, `.btn-ghost`, `.stat-band`, `.stats`, `.stat-num`, `.em`,
`.stat-label`) all match definitions in Task 1's interfaces and CSS. The terminal classes
(`.term-prompt/-ok/-dev/-cmt`) and module/tag/facts/meta classes are reused unchanged from the
existing HTML. ✔
