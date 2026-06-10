This guide walks through both portals as they work **today** (Phase-1/2 mock, on
in-memory data). The interactions are real; the data is seeded. Where live
behaviour will differ, it's called out.

## Run the portals

Each app is a standard Flutter Web project. From either repo:

```bash
flutter pub get
flutter run -d chrome
```

The shared design system and data layer come from `devportal_shared` (a local
`path:` dependency) — no extra setup. To be explicit about the data source:

```bash
flutter run -d chrome --dart-define=DATA_SOURCE=mock   # only mock is wired today
```

!!! tip "Demo credentials"
    **External portal:** no credentials — click **Continue with SSO** (you're mapped
    to demo developer `dev@example.com`, so the seeded apps show).
    **Internal console:** sign in with `admin` / `passWORD1234#` (there's a **Fill**
    button). Both stand in for the ForgeRock SSO used in production.

---

## For external developers

The self-service journey, in order. This is the happy path the portal is built
around.

### 1. Sign in

Click **Continue with SSO**. No form — the stub signs you in and routes you to the
home page. *(Live: this runs the OIDC Authorization Code + PKCE flow against
ForgeRock.)*

### 2. Browse the catalog

- The **home** page leads with a hero spotlight and carousels of featured products.
- **Catalog** lists every API product; use **search** and **filters** to narrow by
  category or access level.
- The headline APIs are the **BIAN payment** products: *Payment Initiation*,
  *Payment Order*, *Payment Execution*.

### 3. Open a product

Each product detail page has three tabs:

- **Overview** — what the API does, access level, and which scopes/products it needs.
- **Documentation** — endpoints, parameters, and example payloads.
- **Try it** — an interactive console: pick an operation, edit the request, and send.

!!! note "Try-it today vs. live"
    On the mock, **Try-it** returns a representative response so you can see the
    shape and status handling. Live, it calls the deployed BIAN proxy with your
    app's credentials and shows the real response.

### 4. Register an app

To get credentials, register an app:

1. Go to **My apps → Register app**.
2. Name the app and select the **products** it should access.
3. Submit. **Public** products **auto-approve**; **restricted** (partner/internal)
   products go to the internal **approval queue**.

### 5. Get your keys

Open the app from **My apps → App detail**:

- **Reveal** and **copy** the consumer key/secret.
- See the **products** the app is entitled to and each one's status.
- Watch **usage analytics** (traffic, latency, errors) for that app.

!!! warning "Keys belong to the app, not to you"
    Signing in identifies *you*; the API keys are minted for the *app* you
    registered. One developer can own several apps, each with its own keys.

### 6. Run an end-to-end flow

**Flows** are guided steppers that chain the three payment APIs into a realistic
journey:

- **Internal transfer** (book transfer) — Initiation → Order → Execution.
- **External transfer** — the same, plus a **clearing/settlement** step.

Each step shows the request, the response, and how one call's output feeds the next
— a fast way to understand the API program without writing code.

### 7. Track usage

Back on **App detail** (or the dashboard), the analytics widgets show your app's
traffic, latency, and error mix over time. *(Live: served from the Apigee stats API
via the BFF.)*

---

## For the internal API team

The admin console produces and governs what external developers consume.

### 1. Sign in

Open `devportal-internal`, sign in with `admin` / `passWORD1234#` (or click
**Fill**). You land on the operations dashboard. *(Live: corporate SSO via ForgeRock,
behind Identity-Aware Proxy.)*

### 2. Read the operations dashboard

At a glance: org **KPIs**, a **traffic** chart, **status-code mix**, **top
products/apps**, and a **pending approvals** card. The approvals count is live — it
reflects the queue in section 5.

### 3. Publish & edit API products

- **Products** lists every API product (the BIAN payment products and others).
- **Create** a new product or **Edit** an existing one — name, access level,
  description, and the proxies/scopes it bundles.
- Changes show in the list immediately. *(Mock: mutations persist for the session.
  Live: written through Drupal to the Apigee management API.)*

### 4. Manage developers

**Developers** lists registered developers with their status and app counts — the
people on the other side of the catalog.

### 5. Work the approval queue

**Approvals** is the queue of app→product requests against **restricted** products:

1. Review each pending request (app, developer, product).
2. **Approve** or **Reject**.
3. The queue updates, and the dashboard's pending count drops.

!!! note "Approval policy is deferred"
    Today the rule is simple: public products auto-approve, restricted products
    queue. The final policy (likely "mixed by product") is a Phase-6 decision; the
    queue mechanism is already real.

### 6. Analytics & settings

- **Analytics** — fuller org-wide traffic, latency, and error analysis.
- **Settings** — illustrative governance, identity, and **monetization** policy.
  Monetization is modelled but not enforced in v1 (Phase 6).

---

## Quick reference

| I want to… | Portal | Where |
|---|---|---|
| Find an API | External | Catalog → search/filter |
| Try a request | External | Product → **Try it** |
| Get API keys | External | Register app → App detail → reveal/copy |
| See a payment journey | External | **Flows** |
| Publish a product | Internal | Products → Create/Edit |
| Approve app access | Internal | Approvals → Approve/Reject |
| Check org traffic | Internal | Dashboard / Analytics |

!!! tip "Lost? Follow the spine"
    External: **sign in → catalog → product → try it → register app → keys → flows →
    usage.** Internal: **sign in → dashboard → products → developers → approvals →
    analytics.** Each step builds on the last.
