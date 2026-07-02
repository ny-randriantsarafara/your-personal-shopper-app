# Architecture

The platform is a monorepo kept deliberately simple so a solo maintainer can own it. Clever abstractions are avoided until the product proves they are needed.

## Apps

- `apps/landing` — public marketing website. Stays simple, fast, and SEO-friendly.
- `apps/customer` — Flutter customer app. Targets iOS and web first, with Android kept in mind. Mobile-first.
- `apps/admin` — Flutter admin app. Web-first for v1, deployed separately from the customer app. Desktop/tablet-first with responsive fallback.
- `apps/api` — NestJS API backed by PostgreSQL via Prisma.

## Packages

- `packages/domain` — shared business names and schemas where reuse is genuinely useful (order statuses, permissions).
- `packages/payments` — shared payment provider codes and normalized statuses.
- `packages/design-tokens` — cross-platform colors, radius, and motion values derived from the design.

Additional packages (`api-client`, `shopper-config`, `flutter-ui`) are introduced only once reuse is proven.

## App boundaries and security

Customer and admin are separate deployable apps, not role-based routes inside one bundle.

- The customer app ships only customer-facing code. It must not include admin screens, admin navigation, or admin-only API modules.
- The admin app is a separate Flutter web deployment. It supports workspace switching after login and only exposes actions allowed by the user's permissions.

The API is the real security boundary. Every protected action must validate:

```text
authenticated user
workspace membership
permission
resource belongs to workspace
```

Frontend visibility is a user-experience layer only. It is not authorization.

## Flutter architecture

Both Flutter apps use Riverpod for state management: it keeps async state explicit without excessive ceremony.

Customer and admin apps follow the same shape:

```text
lib/
  main.dart
  app.dart
  core/       config, routing, theme, auth, api
  features/   one folder per product area
  shared/     widgets, layout, formatting
```

UI migration rules:

- rebuild the React prototype in Flutter; do not embed it in a web view;
- preserve layout, spacing, typography, colors, status labels, cards, and screen hierarchy as closely as Flutter allows;
- use Flutter animations directly (`AnimatedSwitcher`, `AnimatedContainer`, route transitions, focused custom animation);
- extract shared widgets only after repeated use proves they are worth it.

See [ui-migration.md](ui-migration.md) for the per-screen checklist.

## API architecture

NestJS, PostgreSQL, and Prisma. REST-first for maintainability; add generated OpenAPI clients when useful.

```text
apps/api/src/
  main.ts
  app.module.ts
  modules/    auth, users, workspaces, branding, requests, quotes,
              payments, logistics, files, notifications, audit
  common/     guards, decorators, errors, prisma
```

Core data model (grows over time):

```text
Workspace, User, WorkspaceMember, CustomerProfile, ProductRequest,
Quote, Order, Payment, PaymentProviderAccount, Shipment, Message,
FileAttachment, AuditLog
```

Recommended first modules: `auth`, `workspaces`, `requests`, `quotes`, `payments`. Logistics, messages, notifications, and audit come after the request-to-payment flow works end to end.

## Testing strategy

- Landing: build check and basic responsive smoke test.
- Customer Flutter: widget tests for key screens, Riverpod provider tests for async states, golden tests for high-value 1:1 designer screens where useful.
- Admin Flutter: widget tests for tables/forms/settings, permission visibility tests, workspace switching tests.
- API: service unit tests, integration tests for request → quote → payment, permission tests for workspace isolation.
