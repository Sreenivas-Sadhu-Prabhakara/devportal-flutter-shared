#!/usr/bin/env python3
"""Render the developer-portal documentation site.

Markdown sources in ``content/`` are wrapped in a shared cinematic-dark shell
(sidebar nav, breadcrumb, on-this-page TOC) and written as flat HTML next to
this script. Diagrams live in ``assets/diagrams/`` and are referenced from the
Markdown. No server or CI build is required — the output is committed and can be
opened directly or served with ``python3 -m http.server``.

    python3 build.py
"""
from __future__ import annotations

import re
from pathlib import Path

import markdown

ROOT = Path(__file__).resolve().parent
CONTENT = ROOT / "content"

# Sidebar order + page metadata. Title/subtitle are rendered by the template;
# Markdown bodies start at the lead paragraph (no H1) and use ## / ### sections.
PAGES = [
    dict(slug="index", group="Understand", nav="Overview",
         title="Developer Portal — System Documentation",
         subtitle="Internal + external developer portals for Apigee X: how the pieces fit, what ships next, and how it goes live."),
    dict(slug="architecture", group="Understand", nav="Architecture",
         title="Architecture",
         subtitle="The components, who owns what, and how a request travels from a developer's browser to Apigee X."),
    dict(slug="roadmap", group="Plan", nav="Roadmap & what's next",
         title="Roadmap & What Ships Next",
         subtitle="Where the build is today and the phased path from clickable mock to a live, governed platform."),
    dict(slug="integration", group="Plan", nav="Integration path",
         title="Integration Path",
         subtitle="How the mock becomes live: the repository-swap seam, the Drupal BFF, Apigee X APIs, and ForgeRock identity."),
    dict(slug="deployment", group="Plan", nav="Deployment",
         title="Deployment",
         subtitle="How each tier is built, shipped, and operated on Google Cloud — now and as the platform matures."),
    dict(slug="how-to", group="Use", nav="How-to guide",
         title="How-To Guide",
         subtitle="Step-by-step walkthroughs for external developers and the internal API team, on today's clickable mock."),
]

GROUPS = ["Understand", "Plan", "Use"]

# Small inline hub mark, echoing the favicon, for the header wordmark.
BRAND_MARK = """
<svg class="brand-mark" viewBox="0 0 64 64" width="26" height="26" aria-hidden="true">
  <g stroke="#FF3640" stroke-width="3" stroke-linecap="round">
    <line x1="32" y1="32" x2="32" y2="14"/><line x1="32" y1="32" x2="48" y2="23"/>
    <line x1="32" y1="32" x2="48" y2="41"/><line x1="32" y1="32" x2="32" y2="50"/>
    <line x1="32" y1="32" x2="16" y2="41"/><line x1="32" y1="32" x2="16" y2="23"/>
  </g>
  <g fill="#fff" stroke="#E50914" stroke-width="1.7">
    <circle cx="32" cy="14" r="4.3"/><circle cx="48" cy="23" r="4.3"/>
    <circle cx="48" cy="41" r="4.3"/><circle cx="32" cy="50" r="4.3"/>
    <circle cx="16" cy="41" r="4.3"/><circle cx="16" cy="23" r="4.3"/>
  </g>
  <circle cx="32" cy="32" r="10" fill="#E50914" stroke="#08080B"/>
  <circle cx="32" cy="32" r="3.4" fill="#fff"/>
</svg>"""


def sidebar(active: str) -> str:
    out = ['<nav class="side-nav" aria-label="Documentation">']
    for group in GROUPS:
        out.append(f'<div class="nav-group"><span class="nav-group-label">{group}</span><ul>')
        for p in (p for p in PAGES if p["group"] == group):
            href = "index.html" if p["slug"] == "index" else f'{p["slug"]}.html'
            cls = ' class="active" aria-current="page"' if p["slug"] == active else ""
            out.append(f'<li><a href="{href}"{cls}>{p["nav"]}</a></li>')
        out.append("</ul></div>")
    out.append("</nav>")
    return "\n".join(out)


TEMPLATE = """<!doctype html>
<html lang="en" data-page="{slug}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="{subtitle_attr}">
<meta name="theme-color" content="#0B0B0F">
<title>{title} · Developer Portal Docs</title>
<link rel="icon" type="image/svg+xml" href="assets/favicon.svg">
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<a class="skip-link" href="#doc">Skip to content</a>
<header class="topbar">
  <button class="nav-toggle" aria-label="Toggle navigation" aria-expanded="false">
    <span></span><span></span><span></span>
  </button>
  <a class="brand" href="index.html">{mark}<span class="brand-name">Developer&nbsp;Portal</span><span class="brand-badge">Docs</span></a>
  <nav class="top-links" aria-label="Related">
    <a href="architecture.html">Architecture</a>
    <a href="roadmap.html">Roadmap</a>
    <a href="how-to.html">How-to</a>
  </nav>
</header>
<div class="layout">
  <aside class="sidebar" id="sidebar">{sidebar}</aside>
  <div class="sidebar-scrim" hidden></div>
  <main class="main">
    <article class="doc" id="doc">
      <div class="crumb"><a href="index.html">Docs</a> <span>/</span> {nav}</div>
      <header class="doc-head">
        <h1>{title}</h1>
        <p class="lede">{subtitle}</p>
      </header>
      {body}
      <nav class="pager">{pager}</nav>
    </article>
    <aside class="onthispage" aria-label="On this page">{toc}</aside>
  </main>
</div>
<footer class="site-foot">
  <div>
    <strong>Developer Portal</strong> — internal &amp; external · cinematic-dark · Bloc/Cubit + clean architecture
  </div>
  <div class="foot-meta">Generated from <code>docs/content/*.md</code> by <code>build.py</code>. An independent engineering reference; “Apigee” and “Google Cloud” are marks of Google.</div>
</footer>
<script src="assets/site.js" defer></script>
</body>
</html>
"""


def pager(idx: int) -> str:
    parts = []
    if idx > 0:
        prev = PAGES[idx - 1]
        href = "index.html" if prev["slug"] == "index" else f'{prev["slug"]}.html'
        parts.append(f'<a class="pager-prev" href="{href}"><span>Previous</span><strong>{prev["nav"]}</strong></a>')
    else:
        parts.append("<span></span>")
    if idx < len(PAGES) - 1:
        nxt = PAGES[idx + 1]
        href = f'{nxt["slug"]}.html'
        parts.append(f'<a class="pager-next" href="{href}"><span>Next</span><strong>{nxt["nav"]}</strong></a>')
    return "".join(parts)


def build() -> None:
    md = markdown.Markdown(
        extensions=["extra", "admonition", "toc", "sane_lists"],
        extension_configs={"toc": {"toc_depth": "2-3", "permalink": "#"}},
    )
    for idx, page in enumerate(PAGES):
        src = CONTENT / f'{page["slug"]}.md'
        text = src.read_text(encoding="utf-8") if src.exists() else "_Content pending._"
        md.reset()
        body = md.convert(text)
        toc = getattr(md, "toc", "") or ""
        # Only show the rail if there are real entries (more than the wrapper).
        toc_html = (
            f'<div class="otp-inner"><p class="otp-title">On this page</p>{toc}</div>'
            if toc.count("<li>") >= 2 else ""
        )
        subtitle_attr = re.sub(r"<[^>]+>", "", page["subtitle"]).replace('"', "&quot;")
        html = TEMPLATE.format(
            slug=page["slug"],
            title=page["title"],
            subtitle=page["subtitle"],
            subtitle_attr=subtitle_attr,
            nav=page["nav"],
            mark=BRAND_MARK,
            sidebar=sidebar(page["slug"]),
            body=body,
            toc=toc_html,
            pager=pager(idx),
        )
        (ROOT / f'{page["slug"]}.html').write_text(html, encoding="utf-8")
        print(f'  rendered {page["slug"]}.html')


if __name__ == "__main__":
    print("Building developer-portal docs…")
    build()
    print("Done.")
