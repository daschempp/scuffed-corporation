# scuffedcorporation.com

The public site for **Scuffed Corporation** — the umbrella brand for Dylan Schempp's
software projects. The name is a joke; the software isn't.

This is a hand-written static site in a deliberate brutalist style: warm paper,
one mono typeface, one accent color, full dark-mode support. Every claim on it is
true — one engineer, one product in daily production
(Scuffed OS, with WHOOP fitness sync honestly stamped "in dev").

## Structure

```
.
├── styles.css            the entire design system (one stylesheet, all pages)
├── index.html            home          → /
├── about/index.html      about         → /about/
├── projects/index.html   projects      → /projects/
├── privacy/index.html    privacy       → /privacy/
├── 404.html              not-found page (served by the host on missing routes)
├── favicon.svg           the scuffed-corner square mark (light + dark aware)
├── robots.txt            allow all
└── README.md             this file
```

Pages live in directories with an `index.html` so URLs are clean trailing-slash
paths (`/about/`, not `/about.html`). All internal links are root-relative.

## Zero dependencies, zero build

- **No build step.** The files are served exactly as committed. There is nothing
  to install, compile, bundle, or minify.
- **No external requests.** System fonts only, inline SVG only, no CDNs, no
  analytics, no trackers, no cookies, no JavaScript. The colophon on the site
  says this; keep it true.
- To preview locally: `python3 -m http.server 8000` from the repo root, then
  open `http://localhost:8000/`. (Any static file server works; opening files
  via `file://` breaks the root-relative `/styles.css` links.)

## Deploying

The site root **is** the repo root. Build command: **none**. Output directory:
**`/`** (repo root). Custom domain: **scuffedcorporation.com**.

### Cloudflare Pages
1. Pages → Create a project → connect this repo.
2. Framework preset: *None*. Build command: *(leave empty)*. Build output directory: `/`.
3. Custom domains → add `scuffedcorporation.com` (and `www` if desired; redirect www → apex).
4. `404.html` at the root is picked up automatically for missing routes.

### Netlify
1. Add new site → import this repo.
2. Build command: *(leave empty)*. Publish directory: `.` (repo root).
3. Domain settings → add `scuffedcorporation.com`, follow the DNS instructions.
4. `404.html` at the publish root is used automatically as the custom 404 page.

### GitHub Pages
1. Settings → Pages → Source: *Deploy from a branch* → `main`, folder `/ (root)`.
2. Settings → Pages → Custom domain: `scuffedcorporation.com` (this commits a
   `CNAME` file), then enable *Enforce HTTPS* once the certificate is issued.
3. DNS: apex `A` records to GitHub Pages IPs (185.199.108.153 / .109 / .110 /
   .111) and a `CNAME` for `www` pointing at `<user>.github.io`.
4. `404.html` at the root is used automatically.

## Post-deploy checklist

- [ ] `https://scuffedcorporation.com/` loads over HTTPS; `/about/`, `/projects/`,
      and `/privacy/` all resolve with the shared nav highlighting the right page.
- [ ] **Update the WHOOP developer app's privacy-policy URL to
      `https://scuffedcorporation.com/privacy/`** — it currently points at a
      GitHub gist. The registered OAuth redirect is
      `https://scuffedcorporation.com/auth/whoop/callback`; leave that as-is
      (the site does not need to serve that path — it is handled by the
      Scuffed OS backend / OAuth flow, not these static pages).
- [ ] Hit a garbage URL and confirm the custom `404.html` renders with styles.
- [ ] Check light and dark mode (OS-level toggle) and a narrow viewport (~380px).
- [ ] Open devtools → Network and confirm the only requests are this site's own
      files: zero third-party requests, ever.

## Editing rules

- Keep every claim on the site literally true. Statuses in the module grid are
  `live` / `in dev` / `planned` — never promote one early.
- New pages copy the head boilerplate, `.frame` skeleton, nav (with
  `aria-current="page"` on the active link), and shared footer from an existing
  page. The class vocabulary lives in `styles.css`; don't add page-local styles.
- No JavaScript. If a feature seems to need JS, the feature is wrong for this site.
