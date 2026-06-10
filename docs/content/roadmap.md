**Bottom line:** the two portals are built and clickable on mock data (Phases 1–2,
done). The remaining work is a straight line — stand up the Drupal BFF (Phase 3),
swap mock data for live Apigee X data and real identity (Phase 4), deploy and
operate on Google Cloud (Phase 5), then layer on monetization and governance
(Phase 6).

## The phase model

<div class="cards">
  <div class="card"><span class="tag now">Done</span><h3>Phase 1 — External mock</h3><p>Public portal: catalog, Try-it, apps &amp; keys, flows, usage. Clickable on fixtures.</p></div>
  <div class="card"><span class="tag now">Done</span><h3>Phase 2 — Internal mock</h3><p>Admin console: dashboard, products CRUD, developers, approvals, analytics, settings.</p></div>
  <div class="card"><span class="tag next">Next</span><h3>Phase 3 — Drupal BFF</h3><p>Headless Apigee Developer Portal Kit + custom REST + identity federation.</p></div>
  <div class="card"><span class="tag next">Next</span><h3>Phase 4 — Go live</h3><p>Live repositories + ForgeRock OIDC. Real products, keys, analytics, Try-it.</p></div>
  <div class="card"><span class="tag later">Later</span><h3>Phase 5 — Deploy &amp; operate</h3><p>GCP hosting, CI/CD promotion, observability.</p></div>
  <div class="card"><span class="tag later">Later</span><h3>Phase 6 — Monetize &amp; govern</h3><p>Rate plans/billing, approval policy, API hub.</p></div>
</div>

## What's done

Both Flutter apps and the shared package are built, analyze clean, build for web,
and pass their widget + e2e tests. All three repos are committed on `main`.

- **`devportal-external`** — home (hero + carousels), catalog (search/filter),
  product detail (overview · docs · **Try-it**), sign-in (stubbed SSO), my apps,
  register app (auto-approve public, queue restricted), app detail (reveal/copy
  keys, usage), **flows** (internal + external payment journeys).
- **`devportal-internal`** — operations dashboard, products (create/edit),
  developers, approvals queue (approve/reject), analytics, settings.
- **`devportal_shared`** — design tokens + cinematic widgets, domain entities,
  repository interfaces, JSON fixtures, and mock repositories behind them.

## What ships next (Phase 3 — the Drupal BFF)

The immediate work, in order:

1. **Formalize the data contract.** Promote the ad-hoc fixture shapes into an
   explicit **OpenAPI** description of the Flutter ↔ Drupal API. This is the
   contract both the mock and the live client honour.
2. **Scaffold `devportal-drupal`.** Install via **`apigee_kickstart`**; run Drupal
   headless (JSON:API on, no themed pages).

    !!! warning "Local prerequisite not yet installed"
        Phase 3 needs PHP, Composer, and DDEV (or equivalent) on the build machine
        — none are installed locally yet. That's the first blocker to clear.

3. **Connect to Apigee X.** Configure **`apigee_edge`** against the real org
   (*needs org details + a GCP service-account JSON — see open inputs*).
4. **Expose the catalog & apps.** Surface API products, apps, keys, and developers
   over JSON:API.
5. **Build the analytics endpoint.** A **custom Drupal REST** resource that calls
   the Apigee **stats API** and reshapes it into the dashboard's compact series.
6. **Wire identity.** Stand up **`openid_connect`** to federate ForgeRock → Drupal
   user → Apigee developer (*needs ForgeRock OIDC details*).

## Then go live (Phase 4)

1. Implement **Live repositories** in `devportal_shared/data/live/` (a Dio/HTTP
   client) behind the existing interfaces. See the [Integration path](integration.html).
2. Flip the data source: `--dart-define=DATA_SOURCE=live`.
3. Replace the stub auth with the real **OIDC Authorization Code + PKCE** flow in
   `AuthCubit`; retire the hardcoded login.
4. Real **app registration → real consumer keys**; **Try-it** calls hit the
   deployed **BIAN payment** proxies; dashboards read real analytics.

## Cross-cutting, modelled now — built later

- **Monetization (Phase 6).** The domain is already shaped to allow rate plans and
  billing; nothing is built in v1. Settings shows it illustratively.
- **Approvals / governance (Phase 6).** The approval queue is real in the mock;
  the *policy* (likely "mixed by product") is deferred. Today: public products
  auto-approve, restricted products queue.

## Open inputs before the live phases

These are required before Phase 3/4 can be wired (the mock phases do not need them):

| Input | Needed for | Status |
|---|---|---|
| Apigee X **org + env** names | `apigee_edge` connection | Pending |
| GCP **service-account JSON** (apigee viewer/admin) | Drupal → Apigee X auth | Pending |
| **ForgeRock OIDC** issuer, client IDs/secrets, redirect URIs, claim mapping | Identity federation | Pending |
| **Repo location** decision (polyrepo confirmed; remote TBD) | Push / CI | Pending |
| Real **brand assets** (logo/palette/type) | Replace cinematic placeholder tokens | Optional |
| **Hosting target** confirmation (GCP-native) | Phase 5 deploy | Recommended, unconfirmed |

!!! tip "None of this blocks UI work"
    Because the apps run on the mock, feature work, polish, and new screens can
    proceed in parallel with standing up the backend — they meet at the repository
    interface.
