# Developer Portal — documentation site

A small, self-contained **cinematic-dark HTML site** documenting the internal +
external developer portals: architecture, roadmap, the mock→live integration path,
deployment, and a how-to guide. It lives here in the shared package because it
describes the whole polyrepo (`devportal-external`, `devportal-internal`,
`devportal-flutter-shared`).

## View it

The site is **pre-rendered** — open it directly or serve the folder:

```bash
python3 -m http.server -d . 8080   # then open http://localhost:8080
```

Open `index.html` for the overview.

## Edit & rebuild

Content is Markdown in `content/`; the diagrams are hand-authored SVG in
`assets/diagrams/`. Regenerate the HTML after any change:

```bash
pip install markdown
python3 build.py        # content/*.md  ->  *.html
```

## Layout

```
build.py                 Markdown -> themed HTML (shared shell, sidebar, TOC)
content/                 One Markdown file per page (index, architecture, roadmap, …)
assets/
  style.css              Cinematic-dark theme (mirrors devportal_shared tokens)
  site.js                Copy buttons, mobile nav, on-this-page scrollspy
  favicon.svg            The API-node/hub brand mark
  diagrams/              architecture.svg · integration.svg · deployment.svg
index.html … how-to.html Pre-rendered output (committed)
```

## Pages

| Page | Covers |
|---|---|
| `index` | Overview + the system-at-a-glance diagram |
| `architecture` | Every tier, responsibilities, end-to-end request flow |
| `roadmap` | What's built, the phase model, what ships next, open inputs |
| `integration` | The repository swap seam, Drupal BFF, ForgeRock identity |
| `deployment` | GCP-native topology and the delivery maturity path |
| `how-to` | Usage walkthroughs for external developers and internal admins |

> The diagrams render to PNG with ImageMagick (`magick assets/diagrams/architecture.svg out.png`)
> if you need raster copies for slides. The favicon masters live in
> [`../brand/`](../brand).
