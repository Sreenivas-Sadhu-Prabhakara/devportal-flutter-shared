This is the engineering reference for the **developer portal** — a pair of
Flutter Web applications (one **external**, one **internal**) that front an
**Apigee X** API program. It explains how the system is put together today, what
ships in each upcoming phase, how the live integration will work, and how it gets
deployed and operated on Google Cloud. A step-by-step [how-to guide](how-to.html)
covers day-to-day usage.

!!! note "Where things stand today"
    Both portals are built and clickable as **Phase-1/2 mocks**: real UI, real
    navigation, real interactions — running entirely on in-memory JSON fixtures.
    No live backend is wired yet. Everything below marked *Phase 3+* is planned,
    not built.

## The system at a glance

<figure class="diagram">
  <img src="assets/diagrams/architecture.svg" alt="Layered architecture: users, the two Flutter Web portals on a shared package, a headless Drupal BFF, Apigee X, and Google Cloud, with ForgeRock providing identity.">
  <figcaption><strong>Figure 1.</strong> The full target architecture. Solid = built today (on mock data); dashed = planned (Phase 3–5). The same diagram is dissected on the <a href="architecture.html">Architecture</a> page.</figcaption>
</figure>

## Two portals, one shared core

| | **External portal** | **Internal portal** |
|---|---|---|
| Repo | `devportal-external` | `devportal-internal` |
| Audience | Third-party developers, partners, fintechs | The API team (product, platform, support) |
| Shape | Public catalog + self-service | Login-gated admin console |
| Does | Browse APIs, register apps, get keys, **try APIs live**, run payment **flows**, see usage | Publish products, manage developers, work the **approval queue**, watch org analytics |
| Access | Public internet (CDN) | Behind Identity-Aware Proxy / corporate SSO |

Both apps are thin: they depend on **`devportal_shared`**, a single Flutter
package that holds the cinematic design system, the domain model, and the data
layer. That package is where the **mock-to-live swap** happens — see the
[Integration path](integration.html).

## How it's built

- **Front end** — Flutter **Web**, **Bloc/Cubit + clean architecture** (domain /
  data / presentation), `go_router`. Each route owns a Cubit; pages talk only to
  repository *interfaces*.
- **Design** — a token-driven **cinematic dark** theme. Every brand value lives
  in one file (`tokens.dart`), so a real corporate brand is a single-file swap.
- **Backend (planned)** — a **headless Drupal** backend-for-frontend using the
  Apigee Developer Portal Kit, which brokers to the **Apigee X** management and
  analytics APIs. Identity federates from **ForgeRock** (OIDC).
- **Domain** — the running example is **payments**, modelled on **BIAN** service
  domains: *Payment Initiation*, *Payment Order*, *Payment Execution*.

## Read next

<div class="cards">
  <div class="card"><span class="tag now">Understand</span><h3><a href="architecture.html">Architecture →</a></h3><p>Every component, who owns what, and how a request flows end to end.</p></div>
  <div class="card"><span class="tag next">Plan</span><h3><a href="roadmap.html">Roadmap →</a></h3><p>What's done and the phased path from mock to a live, governed platform.</p></div>
  <div class="card"><span class="tag next">Plan</span><h3><a href="integration.html">Integration path →</a></h3><p>The repository swap seam, the Drupal BFF, and ForgeRock identity.</p></div>
  <div class="card"><span class="tag later">Plan</span><h3><a href="deployment.html">Deployment →</a></h3><p>How each tier is built, shipped, and operated on Google Cloud.</p></div>
  <div class="card"><span class="tag now">Use</span><h3><a href="how-to.html">How-to guide →</a></h3><p>Walkthroughs for external developers and the internal API team.</p></div>
</div>

!!! tip "Run the mocks locally"
    From either app repo: `flutter pub get && flutter run -d chrome`. The internal
    console is login-gated — sign in with `admin` / `passWORD1234#`. The external
    portal needs no credentials: click **Continue with SSO**.
