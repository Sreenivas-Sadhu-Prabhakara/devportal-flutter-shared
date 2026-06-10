The portal is a **layered system**: a presentation tier (two Flutter Web apps on
a shared package), a backend-for-frontend (headless Drupal), the Apigee X control
plane, and Google Cloud underneath — with ForgeRock supplying identity. Today only
the presentation tier exists, running on mock data; the tiers below it are the
build targets for Phases 3–5.

<figure class="diagram">
  <img src="assets/diagrams/architecture.svg" alt="The layered architecture diagram showing users, presentation, BFF, platform and cloud tiers.">
  <figcaption><strong>Figure 1.</strong> Target architecture, top to bottom. Each tier is dissected below.</figcaption>
</figure>

## Tier 1 — Presentation (Flutter Web)

Two **separately deployable** apps that share one package. Keeping them separate
means the public app and the staff console have independent release cadences,
hosting, and security postures; sharing a package means the design system, domain
model, and data contracts never drift between them.

### `devportal-external` — the public portal

The self-service experience for third-party developers:

- **Catalog & docs** — browse and search API products; per-product overview,
  documentation, and an interactive **Try-it** console.
- **Apps & keys** — register an app, receive credentials, reveal/copy keys, see
  which products an app is entitled to.
- **Flows** — guided steppers that chain the BIAN payment APIs end to end (an
  internal *book transfer*; an external transfer that adds a clearing/settlement
  step).
- **Usage** — per-app analytics (traffic, latency, errors).

### `devportal-internal` — the admin console

A login-gated, left-rail admin shell for the API team:

- **Operations dashboard** — org KPIs, traffic, status-code mix, top products/apps,
  pending approvals.
- **Products** — create and edit API products (CRUD; mutations persist in-session).
- **Developers** — registered developers, status, app counts.
- **Approvals** — the queue of app→product access requests; approve/reject updates
  the dashboard.
- **Analytics** & **Settings** — fuller org analytics and illustrative governance,
  identity, and monetization policy.

### `devportal_shared` — the shared core

One Flutter package, three layers, consumed by both apps via a local `path:`
dependency:

| Layer | Holds | Notes |
|---|---|---|
| `theme/` | `tokens.dart`, `app_theme.dart` | The only place raw brand values live |
| `widgets/` | PortalMark, PosterCard, Carousel, HeroSpotlight, MetricTile, charts | Cinematic design system |
| `domain/` | entities + **repository interfaces** | The abstraction the UI depends on |
| `data/` | `fixtures/` (JSON) + `mock/` repositories | Live implementations drop in here later |

!!! tip "The architectural keystone"
    The presentation and Bloc layers depend **only** on the repository interfaces
    in `domain/`. They never see JSON, HTTP, Drupal, or Apigee. That single rule
    is what makes the mock-to-live switch a contained, data-layer-only change —
    detailed on the [Integration path](integration.html).

## Tier 2 — Backend-for-frontend (headless Drupal) · Phase 3

A **headless Drupal** site, built on the Apigee Developer Portal Kit, acts as the
BFF between Flutter and Apigee X. Drupal is used **API-only** — no themed Drupal
pages are served to end users.

- **`apigee_edge`** — connects Drupal to the Apigee X org (developers, apps, keys).
- **`apigee_api_catalog`** — manages API products and their documentation.
- **`apigee_kickstart`** — the installation profile that wires these together.
- **`openid_connect`** — federates ForgeRock identity into a Drupal user, which
  maps to an Apigee developer.
- A **custom REST endpoint** reshapes the Apigee **analytics (stats) API** into the
  compact JSON the dashboards expect.

Flutter reaches Drupal over **JSON:API / custom REST** with a bearer token; Drupal
reaches Apigee X with a **GCP service account**.

## Tier 3 — Platform (Apigee X) · Phase 4

Apigee X is the control plane and the **source of truth for live data**:

- **Management API** — products, apps, keys, developers.
- **Analytics / Stats API** — traffic, latency, and error metrics.
- **Runtime** — the deployed API proxies themselves: the **BIAN payment APIs** the
  external Try-it console calls, fronted by OAuth.

## Tier 4 — Identity (ForgeRock, OIDC)

Identity is federated, not owned by the portal:

- In the browser, each Flutter app runs the **Authorization Code + PKCE** flow
  against ForgeRock.
- In Drupal, `openid_connect` federates the ForgeRock identity to a Drupal user →
  Apigee developer.
- **Portal login ≠ app consumer keys.** Signing in identifies the *person*; the API
  keys belong to the *apps* they register.

!!! warning "Mock stands in for identity today"
    Until Phase 4, identity is stubbed: the external portal's *Continue with SSO*
    needs no credentials (and maps to demo developer `dev@example.com`), and the
    internal console uses a hardcoded `admin` / `passWORD1234#` gate. These are
    placeholders for the ForgeRock OIDC flow — never ship them.

## Tier 5 — Google Cloud

The whole thing runs GCP-native: Drupal on **Cloud Run** with **Cloud SQL**,
Flutter Web on **Firebase Hosting** behind a CDN, the internal app additionally
behind **Identity-Aware Proxy**, secrets in **Secret Manager**. Full topology on
the [Deployment](deployment.html) page.

## How a request flows (target state)

1. A developer opens the portal; Flutter loads from the CDN.
2. They sign in — the app runs **OIDC Auth Code + PKCE** against ForgeRock and gets
   a token.
3. A page asks its Cubit for data; the Cubit calls a **repository interface**.
4. The **Live** repository implementation issues an HTTPS request to **Drupal**
   (`JSON:API` / custom REST) with the bearer token.
5. Drupal calls the **Apigee X** management or stats API using the **service
   account**, reshapes the response, and returns compact JSON.
6. The Cubit emits state; the widget rebuilds. The UI code is identical to the mock
   path — only the repository implementation changed.

## Current vs. target

| Concern | Today (mock) | Target (Phase 4+) |
|---|---|---|
| Data source | In-memory JSON fixtures | Live repos → Drupal → Apigee X |
| Identity | Stub SSO / hardcoded login | ForgeRock OIDC (Auth Code + PKCE) |
| Keys & products | Seeded fixtures | Real Apigee apps, keys, products |
| Try-it | Simulated responses | Real calls to deployed BIAN proxies |
| Analytics | Fixture series | Apigee stats API via custom REST |
| Hosting | `flutter run` locally | Firebase Hosting + Cloud Run on GCP |
