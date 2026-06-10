# devportal_shared

Shared Flutter package for the developer-portal apps (internal + external). Holds
the **cinematic design system**, the **domain** model, and the **data layer**
(mock now, live later) so both apps depend on one source of truth.

> Part of a polyrepo: [`devportal-external`](../devportal-external) and
> `devportal-internal` (later) consume this package; `devportal-drupal` is the
> headless BFF. See the portal design notes in the parent project.

## What's inside

```
lib/
  devportal_shared.dart        Barrel export
  src/
    theme/        tokens.dart (cinematic dark tokens), app_theme.dart
    widgets/      PortalMark, PosterCard, Carousel, HeroSpotlight,
                  StatusBadge, SectionHeader, MetricTile, MiniAreaChart, StatBar
    domain/
      entities/   ApiProduct, DeveloperApp, Credential, AppAnalytics
      repositories/  CatalogRepository, AppsRepository, AnalyticsRepository (interfaces)
    data/
      fixtures/   hand-authored JSON (shaped like the live API)
      mock/       Mock{Catalog,Apps,Analytics}Repository
```

## Design tokens

All brand values live in `src/theme/tokens.dart` — a **cinematic dark** theme
(near-black canvas, bold red accent, poster cards, hero spotlights). Swapping a
real corporate brand later is a single-file change.

## Mock → live

The UI/Bloc layer depends only on the repository **interfaces**. Today the mock
implementations decode JSON fixtures via the same path a live HTTP source will
use. In Phase 4 a live implementation (Drupal JSON:API → Apigee X) is dropped in
behind the same interfaces — no UI changes.

## Consume it

From a sibling app's `pubspec.yaml` (local dev):

```yaml
dependencies:
  devportal_shared:
    path: ../devportal-flutter-shared
```

## Develop

```bash
flutter pub get
flutter analyze
flutter test
```
