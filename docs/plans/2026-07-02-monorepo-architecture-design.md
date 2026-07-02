# Personal Shopper Monorepo Architecture Design

Date: 2026-07-02

Status: Approved design, working artifact.

## Goal

Rearrange the current project into a simple monorepo that can support:

- a landing page website;
- a customer-facing Flutter app for iOS and web first, Android-ready later;
- a separate Flutter web admin app;
- a NestJS API;
- multi-workspace personal shopper branding;
- a unified Mobile Money payment layer with provider-specific implementations.

The architecture should stay maintainable by one person. Avoid clever abstractions until the product proves they are needed.

## Current Source Inputs

The current repository contains a static bilingual landing page. The attached designer source is a Vite/React prototype with a large single app component, shadcn-style UI files, mock request/quote/payment flows, and an MVP product spec.

The React prototype is a visual and behavioral reference, not the final runtime. The customer and admin apps will be rebuilt in Flutter with best-effort 1:1 layout, state, interaction, and animation fidelity.

No shopper-specific real name should appear in source, seed data, or generic UI. Use neutral placeholder names only when an example is unavoidable.

## Recommended Monorepo Shape

```text
your-personal-shopper-app/
  apps/
    landing/
    customer/
    admin/
    api/
  packages/
    domain/
    api-client/
    shopper-config/
    payments/
    design-tokens/
    flutter-ui/
  docs/
    plans/
```

### Apps

`apps/landing` contains the public marketing website. It should stay simple, fast, and SEO-friendly.

`apps/customer` contains the Flutter customer app. It targets iOS and web first, with Android kept in mind.

`apps/admin` contains the Flutter admin app. It is web-first only for v1 and is deployed separately from the customer app.

`apps/api` contains the NestJS API.

### Packages

`packages/domain` contains shared business names and schemas where reuse is genuinely useful.

`packages/api-client` contains generated or handwritten client contracts for app/API communication.

`packages/shopper-config` contains only build-time app identity configuration and schemas. Runtime workspace configuration lives in the API/database.

`packages/payments` contains shared payment names, normalized statuses, and provider codes where useful.

`packages/design-tokens` stores cross-platform colors, spacing, typography, and motion values derived from the design.

`packages/flutter-ui` stores Flutter widgets only after they are clearly shared by customer and admin apps.

## Security And App Boundaries

Customer and admin are separate deployable apps, not role-based routes inside one bundle.

The customer app ships only customer-facing code. It must not include admin screens, admin navigation, or admin-only API modules.

The admin app is a separate Flutter web deployment. It supports workspace switching after login and only exposes actions allowed by the user's permissions.

The API remains the real security boundary. Every protected action must validate:

```text
authenticated user
workspace membership
permission
resource belongs to workspace
```

Frontend visibility is only a user-experience layer. It is not authorization.

## Runtime Branding And Workspace Configuration

Most configuration should be editable from the admin app and stored in the API database.

Runtime workspace settings include:

- public brand name;
- logo;
- colors;
- support phone and WhatsApp;
- social links;
- office address;
- legal information;
- default language;
- enabled payment providers;
- Mobile Money receiver accounts;
- commissions;
- exchange rates;
- delivery fees;
- quote validity rules;
- service categories;
- feature flags.

Customer app startup:

```text
app starts
resolve workspace from build-time identity, domain, or deep link
fetch public workspace settings from API
apply branding, feature flags, and payment options at runtime
```

Build-time configuration should be limited to what app stores and platform builds require:

- bundle id;
- app name;
- app icon;
- associated domain;
- default API environment;
- default workspace slug/id for first resolution.

One source codebase can produce multiple customer app builds, but most visible brand content should not require recompilation.

Admin remains one generic app. Admin users switch between the workspaces they belong to.

## Flutter Architecture

Use Flutter for both customer and admin apps.

Use Riverpod for state management. It keeps async state explicit without too much ceremony for a solo maintainer.

Suggested customer app structure:

```text
apps/customer/
  lib/
    main.dart
    app.dart
    core/
      config/
      routing/
      theme/
      auth/
      api/
    features/
      requests/
      quotes/
      payments/
      tracking/
      account/
    shared/
      widgets/
      layout/
      formatting/
```

Suggested admin app structure:

```text
apps/admin/
  lib/
    main.dart
    app.dart
    core/
      config/
      routing/
      theme/
      auth/
      api/
    features/
      dashboard/
      workspaces/
      requests/
      quotes/
      payments/
      logistics/
      users/
      settings/
    shared/
      widgets/
      layout/
      formatting/
```

UI migration rules:

- rebuild the React prototype in Flutter, do not embed it in a web view;
- preserve layout, spacing, typography, colors, status labels, cards, and screen hierarchy as closely as Flutter allows;
- use Flutter animations directly with `AnimatedSwitcher`, `AnimatedContainer`, route transitions, and focused custom animation where needed;
- extract shared widgets only after repeated use proves they are worth it;
- make customer mobile-first;
- make admin desktop/tablet web-first with responsive fallback.

## API Architecture

Use NestJS, PostgreSQL, and Prisma.

Keep the API REST-first for maintainability. Add generated OpenAPI clients when it is useful; start with small handwritten clients if that is simpler.

Suggested API structure:

```text
apps/api/
  src/
    main.ts
    app.module.ts
    modules/
      auth/
      users/
      workspaces/
      branding/
      requests/
      quotes/
      payments/
      logistics/
      files/
      notifications/
      audit/
    common/
      guards/
      decorators/
      errors/
      prisma/
```

Core data model:

```text
Workspace
User
WorkspaceMember
CustomerProfile
ProductRequest
Quote
Order
Payment
PaymentProviderAccount
Shipment
Message
FileAttachment
AuditLog
```

Recommended first modules:

```text
auth
workspaces
requests
quotes
payments
```

Logistics, messages, notifications, and audit should come after the request-to-payment flow works end to end.

## Unified Mobile Money Payment Layer

The apps should consume one normalized payment workflow. Provider-specific behavior stays behind API adapters.

Suggested API module shape:

```text
payments/
  payment.service.ts
  payment.controller.ts
  providers/
    payment-provider.interface.ts
    mvola.provider.ts
    orange-money.provider.ts
    airtel-money.provider.ts
    manual-mobile-money.provider.ts
```

Provider interface:

```ts
interface PaymentProvider {
  providerCode: 'MVOLA' | 'ORANGE_MONEY' | 'AIRTEL_MONEY' | 'MANUAL_MOBILE_MONEY';

  createPaymentIntent(input): Promise<PaymentIntentResult>;
  getPaymentStatus(providerReference): Promise<PaymentStatusResult>;
  refundPayment(input): Promise<RefundResult>;
  handleWebhook(payload, headers): Promise<WebhookResult>;
}
```

Normalized payment record:

```text
Payment
- id
- workspaceId
- orderId or quoteId
- provider
- amountMGA
- status
- customerPhone
- receiverAccountId
- providerReference
- checkoutUrl or instructions
- failureReason
- verifiedAt
- refundedAt
```

Normalized customer-facing statuses:

```text
pending
waiting_customer_action
processing
paid
failed
expired
refunded
```

Recommended v1 payment strategy:

- implement the real data model;
- implement the adapter interface;
- make `MANUAL_MOBILE_MONEY` fully functional;
- scaffold MVola, Orange Money, and Airtel Money adapters behind the same interface;
- add real provider integrations one by one when credentials and provider documentation are available.

This lets the product ship without blocking on third-party payment onboarding.

## Testing Strategy

Landing:

- build check;
- basic responsive smoke test.

Customer Flutter:

- widget tests for key screens;
- Riverpod provider tests for async states;
- screenshot/golden tests for high-value 1:1 designer screens where useful.

Admin Flutter:

- widget tests for tables, forms, and settings;
- permission visibility tests;
- workspace switching tests.

API:

- service unit tests;
- integration tests for request to quote to payment;
- permission tests for workspace isolation.

## Migration Flow

1. Move the current landing page into `apps/landing`.
2. Store the designer source as a reference artifact, not production runtime.
3. Create the Flutter customer app.
4. Rebuild customer UI from the designer prototype.
5. Create the Flutter admin web app.
6. Rebuild admin, workspace, payment, and settings UI from the designer prototype.
7. Create the NestJS API with Prisma.
8. Connect apps through small typed API clients.
9. Add runtime workspace branding from admin/API.
10. Add the payment layer with manual Mobile Money first, provider adapters next.

## Documentation Intent

This file is a temporary working artifact during planning and implementation.

Promote these ideas into permanent documentation after implementation validates them:

- app boundary and security rules;
- runtime workspace branding model;
- payment adapter interface and payment statuses;
- local development commands;
- release/build process for per-shopper customer app builds.

Delete or archive this design doc after those permanent docs exist and the implementation plan is complete.
